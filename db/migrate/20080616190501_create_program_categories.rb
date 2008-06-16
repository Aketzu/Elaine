class CreateProgramCategories < ActiveRecord::Migration
  def self.up
    create_table :program_categories do |t|
      t.string :name
      t.string :description
      t.boolean :default_do_vod
      t.boolean :default_hidden

      t.timestamps
    end
  end

  def self.down
    drop_table :program_categories
  end
end
