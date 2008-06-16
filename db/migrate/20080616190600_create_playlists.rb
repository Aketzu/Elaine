class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.integer :program_id
      t.integer :channel_id
      t.datetime :start_at
      t.boolean :movable

      t.timestamps
    end
		add_index :playlists, [:program_id, :channel_id]
		add_index :playlists, :start_at
  end

  def self.down
    drop_table :playlists
  end
end
