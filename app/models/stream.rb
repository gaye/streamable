class Stream < ActiveRecord::Base
  belongs_to :publisher, :foreign_key => 'publisher_id', :class_name => 'User'
  has_many :subscriptions
  
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
end
