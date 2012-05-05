=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class Stream < ActiveRecord::Base
  S3_BASE_URL = 'http://s3.amazonaws.com'
  ENCODE_NOTIFY_URL = 'http://staging.streamable.tv/streams/encode_notify'
  
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
    streams = Set.new
    tags.each do |tag|
      streams_with_tag = Tag.find_by_name(tag, :include => :streams).streams
      streams_with_tag.delete_if {|stream| !stream.zencoder_state}
      streams_with_tag.each {|stream| streams << stream}
    end
    
    streams.to_a
  end
  
  def encode!
    original_file_path = s3_url_to_path(self.video_preview.url)
    stripped_file_path = strip_extension(original_file_path)
    webm_file_path = "#{stripped_file_path}.webm"
    thumb_file_path = "#{stripped_file_path}.png"
    
    response = Zencoder::Job.create({
      :input => "s3://#{original_file_path}",
      :outputs => [
        { 
          :url => "s3://#{webm_file_path}", 
          :notifications => [{:format => 'json', :url => ENCODE_NOTIFY_URL}] 
        },
        { 
          :thumbnails => [{ 
            :number => 1,
            :label => 'Video Preview Thumbnails',
            :url => "s3://#{thumb_file_path}" 
          }] 
        }
      ],
      :test => true
    })
    
    self.zencoder_output_url = "#{S3_BASE_URL}/#{webm_file_path}"
    self.zencoder_thumbnail_url = "#{S3_BASE_URL}/#{thumb_file_path}"
    self.zencoder_id = response.body['id'].to_i
    self.save
  end
  
  def capture_notification(output)
    if output[:state] == 'finished'
      self.zencoder_state = true
      self.save
    end
  end
  
  private
  
  def s3_url_to_path(url)
    url.gsub("#{S3_BASE_URL}/", '').split('?').first
  end
  
  def strip_extension(file_name)
    file_name[0, file_name.rindex('.')]
  end
end
