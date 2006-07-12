class CreateTapeProgramLinks < ActiveRecord::Migration
  def self.up
    create_table :tape_program_links do |t|
      # t.column :name, :string
      t.column :offset,     :time
      t.column :tape_id,    :integer
      t.column :program_id, :integer
    end

    execute "ALTER TABLE tape_program_links ADD CONSTRAINT tape FOREIGN KEY
    (tape_id) REFERENCES tapes (id);"
    execute "ALTER TABLE tape_program_links ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
  end

  def self.down
    execute "ALTER TABLE tape_program_links DROP CONSTRAINT tape;"
    execute "ALTER TABLE tape_program_links DROP CONSTRAINT program;"
    drop_table :tape_program_links
  end
end
