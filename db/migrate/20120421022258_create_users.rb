class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.integer :facebook_uid
      t.string  :first_name
      t.string  :last_name
      t.string  :image_url
      t.string  :token
      t.integer :token_expiration
      t.text    :raw
      t.timestamps
    end
    
    add_index :users, :facebook_uid
  end

  def down
    drop_table :users
  end
end
