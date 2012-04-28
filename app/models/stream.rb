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
  
  before_video_preview_post_process do |stream|
    !stream.video_preview_changed?
  end
  
  after_save do |stream|
    Delayed::Job.enqueue(SendToAmazonJob.new(stream.id)) if stream.video_preview_changed?
  end
  
  # TODO(gaye): If possible, replace this with a has_many :through
  def subscribers
    subscriptions.map(&:user)
  end
  
  def subscribed?(user)
    subscribers.include?(user)
  end
  
  def video_preview_changed?
    self.video_preview_file_size_changed? || 
    self.video_preview_file_name_changed? ||
    self.video_preview_content_type_changed? || 
    self.video_preview_updated_at_changed?
  end
end
