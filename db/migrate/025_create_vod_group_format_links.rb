class CreateVodGroupFormatLinks < ActiveRecord::Migration
  def self.up
    create_table :vod_group_format_links do |t|
      # t.column :name, :string
      t.column :vod_group_id,   :integer
      t.column :vod_format_id,  :integer
    end

    execute "ALTER TABLE vod_group_format_links ADD CONSTRAINT vod_group FOREIGN KEY
    (vod_group_id) REFERENCES vod_groups (id);"
    execute "ALTER TABLE vod_group_format_links ADD CONSTRAINT vod_format FOREIGN KEY
    (vod_format_id) REFERENCES vod_formats (id);"
  end

  def self.down
    execute "ALTER TABLE vod_group_format_links DROP CONSTRAINT vod_group;"
    execute "ALTER TABLE vod_group_format_links DROP CONSTRAINT vod_format;"
    drop_table :vod_group_format_links
  end
end
