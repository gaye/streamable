=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class Stream < ActiveRecord::Base
  S3_BASE_URL = 'http://s3.amazonaws.com'
  
  attr_accessible :publisher_id,
                  :title,
                  :description,
                  :when,
                  :video_preview,
                  :opentok_session_id,
                  :publisher_token,
                  :price,
                  :video_preview_file_name,
                  :video_preview_thumbnail_file_name, 
                  :zencoder_id
  
  belongs_to :publisher, :foreign_key => 'publisher_id', :class_name => 'User'
  has_many :subscriptions
  has_and_belongs_to_many :tags
  
  has_attached_file :video_preview,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/s3.yml"
  has_attached_file :thumbnail
  
  validates_presence_of :publisher,
                        :title,
                        :description,
                        :when,
                        :video_preview,
                        :opentok_session_id,
                        :publisher_token
  
  # TODO(gaye): If possible, replace this with a has_many :through
  def subscribers
    subscriptions.each(&:user)
  end
  
  def subscribed?(user)
    subscribers.include?(user)
  end
  
  # Expects an array of tags as input
  def self.find_by_tags(tags)
    streams = nil
    tags.each do |tag|
      # Make sure we're loading the streams of the tags eagerly
      streams_with_tag = Tag.find_by_name(tag, :include => :streams).streams
      streams ||= streams_with_tag
      streams.delete_if {|stream| !stream.zencoder_state}
      streams = streams & streams_with_tag
      break if streams.empty?
    end
    
    streams
  end
  
  def encode!
    original_file_path = url_to_path(self.video_preview.url)
    stripped_file_path = strip_extension(original_file_path)
    webm_file_path = "#{stripped_file_path}.webm"
    thumb_file_path = "#{stripped_file_path}.png"
    
    response = Zencoder::Job.create({
      :input => "s3://#{original_file_path}",
      :outputs => [
        { 
          :url => "s3://#{webm_file_path}", 
          :notifications => [{ 
            :format => 'json',
            :url => 'http://staging.streamable.tv/streams/encode_notify'
          }] 
        },
        { 
          :thumbnails => [{ 
            :number => 1,
            :label => strip_extension(self.video_preview_file_name),
            :url => "s3://#{thumb_file_path}" 
          }] 
        }
      ],
      :test => true
    })
    
    self.zencoder_output_url = "#{S3_BASE_URL}/#{webm_file_path}"
    self.zencoder_id = response.body['id'].to_i
    self.save
  end
  
  def capture_notification(output)
    if output[:state] == 'finished'
      self.zencoder_state = true
      self.zencoder_output_url = output[:url]
      self.thumbnail = 
          open(URI.parse("#{S3_BASE_URL}/#{s3_base_path}/thumbnails_#{self.id}/frame_0000.png"))
      self.thumbnail_content_type = 'image/png'
    end
    
    self.save
  end
  
  private
  
  def url_to_path(url)
    url.gsub("#{S3_BASE_URL}/", '').split('?').first
  end
  
  def strip_extension(file_name)
    file_name[0, file_name.rindex('.')]
  end
  
  def s3_base_path
    "streamable-#{Rails.env.production? ? 'pro' : 'dev'}"
  end
end
