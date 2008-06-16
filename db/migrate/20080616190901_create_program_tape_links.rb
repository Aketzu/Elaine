class CreateProgramTapeLinks < ActiveRecord::Migration
  def self.up
    create_table :program_tape_links do |t|
      t.integer :program_id
      t.integer :tape_id
      t.integer :start_at

      t.timestamps
    end
		add_index :program_tape_links, [:program_id, :tape_id]
  end

  def self.down
    drop_table :program_tape_links
  end
end
