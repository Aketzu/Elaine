class AddTubeToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :tube, :string
  end

  def self.down
    remove_column :programs, :tube
  end
end
