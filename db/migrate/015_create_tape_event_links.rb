class CreateTapeEventLinks < ActiveRecord::Migration
  def self.up
    create_table :tape_event_links do |t|
      # t.column :name, :string
      t.column :offset,   :time
      t.column :tape_id,  :integer
      t.column :event_id, :integer
    end

    execute "ALTER TABLE tape_event_links ADD CONSTRAINT tape FOREIGN KEY
    (tape_id) REFERENCES tapes (id);"
    execute "ALTER TABLE tape_event_links ADD CONSTRAINT event FOREIGN KEY
    (event_id) REFERENCES events (id);"
  end

  def self.down
    execute "ALTER TABLE tape_event_links DROP CONSTRAINT tape;"
    execute "ALTER TABLE tape_event_links DROP CONSTRAINT event;"
    drop_table :tape_event_links
  end
end
