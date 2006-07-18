class CreateProgramEventLinks < ActiveRecord::Migration
  def self.up
    create_table :program_event_links do |t|
      # t.column :name, :string
      t.column :position,   :integer
      t.column :program_id, :integer
      t.column :event_id,   :integer
    end

    execute "ALTER TABLE program_event_links ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
    execute "ALTER TABLE program_event_links ADD CONSTRAINT event FOREIGN KEY
    (event_id) REFERENCES events (id);"
  end

  def self.down
    execute "ALTER TABLE program_event_links DROP CONSTRAINT program;"
    execute "ALTER TABLE program_event_links DROP CONSTRAINT event;"
    drop_table :program_event_links
  end
end
