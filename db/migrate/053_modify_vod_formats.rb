class ModifyVodFormats < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE vod_group_format_links DROP CONSTRAINT vod_format;"
    execute "ALTER TABLE vods DROP CONSTRAINT vod_format;"
    rename_table :vod_formats, :video_formats
    rename_column :vod_group_format_links, :vod_format_id, :video_format_id
    rename_column :vods, :vod_format_id, :video_format_id
    execute "ALTER TABLE vod_group_format_links ADD CONSTRAINT video_format FOREIGN KEY
    (video_format_id) REFERENCES video_formats (id);"
    execute "ALTER TABLE vods ADD CONSTRAINT video_format FOREIGN KEY
    (video_format_id) REFERENCES video_formats (id);"

    add_column :video_formats, :mime_type, :string
    add_column :video_formats, :file_extension, :string
    add_column :video_formats, :use_for_vods, :string
    add_column :video_formats, :use_for_production, :string
  end

  def self.down
    remove_column :video_formats, :mime_type
    remove_column :video_formats, :file_extension
    remove_column :video_formats, :use_for_vods
    remove_column :video_formats, :use_for_production

    execute "ALTER TABLE vod_group_format_links DROP CONSTRAINT video_format;"
    execute "ALTER TABLE vods DROP CONSTRAINT video_format;"
    rename_table :video_formats, :vod_formats
    rename_column :vod_group_format_links, :video_format_id, :vod_format_id
    rename_column :vods, :video_format_id, :vod_format_id
    execute "ALTER TABLE vod_group_format_links ADD CONSTRAINT vod_format FOREIGN KEY
    (vod_format_id) REFERENCES vod_formats (id);"
    execute "ALTER TABLE vods ADD CONSTRAINT vod_format FOREIGN KEY
    (vod_format_id) REFERENCES vod_formats (id);"

  end
end
