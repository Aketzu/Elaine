class CreateProgramUserLinks < ActiveRecord::Migration
  def self.up
    create_table :program_user_links do |t|
      t.integer :program_id
      t.integer :user_id

      t.timestamps
    end
		add_index :program_user_links, [:program_id, :user_id]
  end

  def self.down
    drop_table :program_user_links
  end
end
