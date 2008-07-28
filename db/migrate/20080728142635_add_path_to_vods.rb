class AddPathToVods < ActiveRecord::Migration
  def self.up
    add_column :vods, :full_path, :string
  end

  def self.down
    remove_column :vods, :full_path
  end
end
