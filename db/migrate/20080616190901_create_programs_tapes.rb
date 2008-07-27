require 'migration_helpers'
class CreateProgramsTapes < ActiveRecord::Migration
  def self.up
    create_table :programs_tapes  do |t|
      t.integer :program_id
      t.integer :tape_id
      t.integer :start_at
    end
		add_index :programs_tapes, [:program_id, :tape_id]

		foreign_key :programs_tapes, :program_id, :delete => "cascade"
		foreign_key :programs_tapes, :tape_id, :delete => "cascade"
  end

  def self.down
		drop_foreign_key :programs_tapes, :program_id
		drop_foreign_key :programs_tapes, :tape_id
    drop_table :programs_tapes
  end
end
