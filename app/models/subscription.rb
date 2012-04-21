class Subscription < ActiveRecord::Base
  belongs_to :stream
  belongs_to :user, :primary_key => 'subscriber_id', :foreign_key => 'user_id', :class_name => User
end
