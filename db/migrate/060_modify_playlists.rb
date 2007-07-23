class ModifyPlaylists < ActiveRecord::Migration
  def self.up
    add_column :playlists, :no_listing, :boolean
  end

  def self.down
    remove_column :playlists, :no_listing
  end
end
