class ModifyEventsVideoFormats < ActiveRecord::Migration
  def self.up
		add_column :events, :video_format_id, :integer
  end

  def self.down
		remove_column :events, :video_format_id
  end
end
