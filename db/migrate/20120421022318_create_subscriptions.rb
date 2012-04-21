class CreateSubscriptions < ActiveRecord::Migration
  def up
    create_table :subscriptions do |t|
      t.references :subscriber
      t.references :stream
    
      t.timestamps
    end
  end

  def down
    drop_table :subscriptions
  end
end
