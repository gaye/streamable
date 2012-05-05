class AddZencoderToStreams < ActiveRecord::Migration
  def change
    change_table :streams do |t|
      t.has_attached_file :thumbnail
      t.integer           :zencoder_id
      t.boolean           :zencoder_state, :default => false
      t.string            :zencoder_output_url
    end
    
    add_index :streams, :zencoder_id
    add_index :streams, :zencoder_state
  end
end
