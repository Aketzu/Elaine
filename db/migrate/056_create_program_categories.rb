class CreateProgramCategories < ActiveRecord::Migration
  def self.up
    create_table :program_categories do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :vod_group_id, :integer
    end
    execute "ALTER TABLE program_categories ADD CONSTRAINT vod_group FOREIGN KEY
    (vod_group_id) REFERENCES vod_groups (id);"
  end

  def self.down
      execute "ALTER TABLE program_categories DROP CONSTRAINT vod_group;"

    drop_table :program_categories
  end
end
