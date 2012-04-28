class AddSubscriberTokenToSubscriptions < ActiveRecord::Migration
  def up
    add_column :subscriptions, :subscriber_token, :text
  end
  
  def down
    remove_column :subscriptions, :subscriber_token
  end
end
