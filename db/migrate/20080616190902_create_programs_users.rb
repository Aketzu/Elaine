require 'migration_helpers'
class CreateProgramsUsers < ActiveRecord::Migration
  def self.up
    create_table :programs_users do |t|
      t.integer :program_id
      t.integer :user_id
			t.string :usertype
    end
		add_index :programs_users, [:program_id, :user_id]
		foreign_key :programs_users, :program_id, :delete => "cascade"
		foreign_key :programs_users, :user_id, :delete => "cascade"
  end

  def self.down
		drop_foreign_key :programs_users, :program_id
		drop_foreign_key :programs_users, :user_id
    drop_table :programs_users
  end
end
