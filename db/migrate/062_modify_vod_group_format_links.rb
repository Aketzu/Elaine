class ModifyVodGroupFormatLinks < ActiveRecord::Migration
  def self.up
		remove_column :vod_group_format_links, :id
  end

  def self.down
		add_column :vod_group_format_links, :id, :primary_key
  end
end
