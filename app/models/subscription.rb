=begin
  Author : Gareth Aye (gareth@streamable.tv)
  Date : 04/21/12
=end
class Subscription < ActiveRecord::Base
  belongs_to :stream
  belongs_to :user, :primary_key => 'subscriber_id', :foreign_key => 'user_id', :class_name => User
end
