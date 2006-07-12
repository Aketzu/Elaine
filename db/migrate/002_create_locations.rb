class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end

    Location.create(
    :name => 'none', 
    :description => %{ none })
    Location.create(
    :name => 'Areena Studio', 
    :description => %{ Areena Studio })
    Location.create(
    :name => 'Hall AV', 
    :description => %{ Hall AV })
  end

  def self.down
    drop_table :locations
  end
end
