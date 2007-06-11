class CreateFileLocations < ActiveRecord::Migration
  def self.up
    create_table :file_locations do |t|
      t.column :name,   :string
      t.column :description, :text
      t.column :url,    :string
      t.column :checker_url, :string
    end
  end

  def self.down
    drop_table :file_locations
  end
end