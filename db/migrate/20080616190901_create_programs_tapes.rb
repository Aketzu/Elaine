class CreateProgramsTapes < ActiveRecord::Migration
  def self.up
    create_table :programs_tapes  do |t|
      t.integer :program_id
      t.integer :tape_id
      t.integer :start_at
    end
		add_index :programs_tapes, [:program_id, :tape_id]
  end

  def self.down
    drop_table :programs_tapes
  end
end
