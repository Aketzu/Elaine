class CreateVodGroups < ActiveRecord::Migration
  def self.up
    create_table :vod_groups do |t|
      t.column :name, :string
      t.column :description, :text
    end
  end

  def self.down
    drop_table :vod_groups
  end
end
