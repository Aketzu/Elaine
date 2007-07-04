class ModifyFileLocations < ActiveRecord::Migration
  def self.up
    add_column :file_locations, :use_for_vods, :string
    add_column :file_locations, :use_for_production, :string
  end

  def self.down
    remove_column :file_locations, :use_for_vods, :string
    remove_column :file_locations, :use_for_production, :string
  end
end
