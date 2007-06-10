class CreateReferenceLogEntries < ActiveRecord::Migration
  def self.up
    create_table :reference_log_entries do |t|
      t.column  :tape_id,     :integer
      t.column  :start_time,  :timestamp
      t.column  :end_time,    :timestamp
      t.column  :channel_id,  :integer
    end
    
    execute "ALTER TABLE reference_log_entries ADD CONSTRAINT tape FOREIGN KEY
    (tape_id) REFERENCES tapes (id);"    
    execute "ALTER TABLE reference_log_entries ADD CONSTRAINT channel FOREIGN KEY
    (channel_id) REFERENCES channels (id);"    
  end

  def self.down
    execute "ALTER TABLE reference_log_entries DROP CONSTRAINT tape;"  
    execute "ALTER TABLE reference_log_entries DROP CONSTRAINT channel;"  
    drop_table :reference_log_entries
  end
end
