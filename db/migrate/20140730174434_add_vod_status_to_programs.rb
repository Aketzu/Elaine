class AddVodStatusToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :vod_status, :integer
  end

  def self.down
    remove_column :programs, :vod_status
  end
end
