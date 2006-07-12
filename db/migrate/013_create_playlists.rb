class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      # t.column :name, :string
      t.column :time,       :timestamp
      t.column :movable,    :boolean
      t.column :program_id, :integer
      t.column :channel_id, :integer, :default => Channel.find(:first, :conditions => [ "name = ?",'AssemblyTV 2006' ]).id
    end

    execute "ALTER TABLE playlists ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
    execute "ALTER TABLE playlists ADD CONSTRAINT channel FOREIGN KEY
    (channel_id) REFERENCES channels (id);"
  end

  def self.down
    execute "ALTER TABLE playlists DROP CONSTRAINT program;"
    execute "ALTER TABLE playlists DROP CONSTRAINT channel;"
    drop_table :playlists
  end
end
