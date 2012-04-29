=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class Stream < ActiveRecord::Base
  attr_accessible :publisher_id,
                  :title,
                  :description,
                  :when,
                  :video_preview,
                  :opentok_session_id,
                  :publisher_token,
                  :price
                  
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
    subscriptions.map(&:user)
  end
  
  def subscribed?(user)
    subscribers.include?(user)
  end
  
  # Expects an array of tags as input
  def self.find_by_tags(tags)
    tags.each do |tag|
      streams_with_tag = Tag.find_by_name(tag).streams
      streams ||= streams_with_tag
      streams = streams & streams_with_tag
      break if streams.empty?
    end
    
    streams
  end
end
