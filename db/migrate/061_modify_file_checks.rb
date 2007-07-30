class ModifyFileChecks < ActiveRecord::Migration
  def self.up
		add_column :events, :file_exists, :boolean
		add_column :events, :file_status_updated, :datetime
		add_column :programs, :file_exists, :boolean
		add_column :programs, :file_status_updated, :datetime
		add_column :vods, :file_exists, :boolean
		add_column :vods, :file_status_updated, :datetime

  end

  def self.down
		remove_column :events, :file_exists
		remove_column :events, :file_status_updated
		remove_column :programs, :file_exists
		remove_column :programs, :file_status_updated
		remove_column :vods, :file_exists
		remove_column :vods, :file_status_updated
  end
end
