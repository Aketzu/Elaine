class CreateProgramDescriptions < ActiveRecord::Migration
  def self.up
    create_table :program_descriptions do |t|
      t.integer :program_id
      t.string :lang
      t.string :title
      t.string :description

      t.timestamps
    end
		add_index :program_descriptions, :program_id
  end

  def self.down
    drop_table :program_descriptions
  end
end
