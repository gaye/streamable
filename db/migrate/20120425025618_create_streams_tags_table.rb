class CreateStreamsTagsTable < ActiveRecord::Migration
  def change
    create_table :streams_tags, :id => false do |t|
      t.integer :stream_id
      t.integer :tag_id
    end
  end
end
