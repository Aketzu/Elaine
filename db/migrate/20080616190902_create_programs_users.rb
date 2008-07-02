class CreateProgramsUsers < ActiveRecord::Migration
  def self.up
    create_table :programs_users do |t|
      t.integer :program_id
      t.integer :user_id
			t.string :usertype
    end
		add_index :programs_users, [:program_id, :user_id]
  end

  def self.down
    drop_table :programs_users
  end
end
