class AddZencoderToStreams < ActiveRecord::Migration
  def change
    change_table :streams do |t|
      t.integer           :zencoder_id
      t.boolean           :zencoder_state, :default => false
      t.string            :zencoder_output_url
      t.string            :zencoder_thumbnail_url
    end
    
    add_index :streams, :zencoder_id
    add_index :streams, :zencoder_state
  end
end
