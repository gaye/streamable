=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class User < ActiveRecord::Base
  attr_accessible :facebook_uid,
                  :first_name,
                  :last_name,
                  :image_url,
                  :raw,
                  :token,
                  :token_expiration
                  
  has_many :subscriptions, :foreign_key => 'subscriber_id'
  has_many :streams_as_publisher, :foreign_key => 'publisher_id', :class_name => 'Stream'
  
  validates_presence_of :facebook_uid, 
                        :first_name, 
                        :last_name, 
                        :image_url, 
                        :token, 
                        :token_expiration
  
  # TODO(gaye): If possible, replace this with a has_many :through
  def streams_as_subscriber
    subscriptions.each(&:stream)
  end
end
