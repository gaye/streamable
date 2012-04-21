class User < ActiveRecord::Base
  has_many :subscriptions, :foreign_key => 'subscriber_id'
  has_many :streams_as_publisher, :foreign_key => 'publisher_id', :class_name => 'Stream'
  
  validates_presence_of :facebook_uid, :first_name, :last_name, :image_url, :token, :token_expiration
  
  # TODO(gaye): If possible, replace this with a has_many :through
  def streams_as_subscriber
    subscriptions.map(&:stream)
  end
end
