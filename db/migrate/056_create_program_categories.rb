class CreateProgramCategories < ActiveRecord::Migration
  def self.up
    create_table :program_categories do |t|
    end
  end

  def self.down
    drop_table :program_categories
  end
end
