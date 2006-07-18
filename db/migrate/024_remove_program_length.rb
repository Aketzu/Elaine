class RemoveProgramLength < ActiveRecord::Migration
  def self.up
    remove_column :programs, :length
  end

  def self.down
    add_column :programs, :length, :integer
  end
end
