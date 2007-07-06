class ModifyFileLocations < ActiveRecord::Migration
  def self.up
    add_column :file_locations, :use_for_vods, :boolean
    add_column :file_locations, :use_for_production, :boolean
  end

  def self.down
    remove_column :file_locations, :use_for_vods
    remove_column :file_locations, :use_for_production
  end
end
