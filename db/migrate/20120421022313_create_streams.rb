class CreateStreams < ActiveRecord::Migration
  def up
    create_table :streams do |t|
      t.references        :publisher
      t.string            :title
      t.text              :description
      t.datetime          :when
      t.float             :price
      t.has_attached_file :video_preview
      t.text              :opentok_session_id
      t.text              :publisher_token
      
      t.timestamps
    end
    
    add_index :streams, :publisher_id
  end

  def down
    drop_table :streams
  end
end
