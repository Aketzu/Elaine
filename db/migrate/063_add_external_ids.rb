class AddExternalIds < ActiveRecord::Migration
  def self.up

    add_column :programs, :external_id, :integer
    add_column :events, :external_id, :integer

  
  end

  def self.down
    remove_column :programs, :external_id
    remove_column :events, :external_id
  end
end
