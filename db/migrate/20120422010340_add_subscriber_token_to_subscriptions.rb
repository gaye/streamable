class AddSubscriberTokenToSubscriptions < ActiveRecord::Migration
  def self.up
    add_column :subscriptions, :subscriber_token, :string
  end
  
  def self.down
    remove_column :subscriptions, :subscriber_token
  end
end
