require 'migration_helpers'
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
		
		foreign_key :playlists, :program_id, :delete => "cascade"
		foreign_key :playlists, :channel_id, :delete => "cascade"
  end

  def self.down
		drop_foreign_key :playlists, :program_id
		drop_foreign_key :playlists, :channel_id
    drop_table :playlists
  end
end
