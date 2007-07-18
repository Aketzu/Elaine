class ModifyPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :tags, :string
    add_column :programs, :video_format_id, :integer
    execute "ALTER TABLE programs ADD CONSTRAINT video_format FOREIGN KEY
    (video_format_id) REFERENCES video_formats (id);"
    add_column :programs, :target_length, :integer
    add_column :programs, :no_listing, :boolean

    execute "ALTER TABLE programs DROP CONSTRAINT vod_group;"
    remove_column :programs, :vod_group_id

    add_column :programs, :program_category_id, :integer
    execute "ALTER TABLE programs ADD CONSTRAINT program_category FOREIGN KEY
    (program_category_id) REFERENCES program_categories (id);"

  
  end

  def self.down
    execute "ALTER TABLE programs DROP CONSTRAINT program_category;"
    remove_column :programs, :program_category_id

    add_column :programs, :vod_group_id, :integer
    execute "ALTER TABLE programs ADD CONSTRAINT vod_group FOREIGN KEY
    (vod_group_id) REFERENCES vod_groups (id);"

    remove_column :programs, :tags
    execute "ALTER TABLE programs DROP CONSTRAINT video_format;"
    remove_column :programs, :video_format_id
    remove_column :programs, :target_length  
    remove_column :programs, :no_listing
  end
end
