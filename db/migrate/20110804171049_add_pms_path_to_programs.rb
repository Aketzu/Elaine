class AddPmsPathToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :pms_path, :string
  end

  def self.down
    remove_column :programs, :pms_path
  end
end
