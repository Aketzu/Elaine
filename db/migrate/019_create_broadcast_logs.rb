class CreateBroadcastLogs < ActiveRecord::Migration
  def self.up
    create_table :broadcast_logs do |t|
      # t.column :name, :string
      t.column :start_time,       :timestamp
      t.column :end_time,       :timestamp
      t.column :program_id, :integer
      t.column :channel_id, :integer, :default => Channel.find(:first, :conditions => [ "name = ?",'AssemblyTV 2006' ]).id
    end

    execute "ALTER TABLE broadcast_logs ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
    execute "ALTER TABLE broadcast_logs ADD CONSTRAINT channel FOREIGN KEY
    (channel_id) REFERENCES channels (id);"
  end

  def self.down
    execute "ALTER TABLE broadcast_logs DROP CONSTRAINT program;"
    execute "ALTER TABLE broadcast_logs DROP CONSTRAINT channel;"
    drop_table :broadcast_logs
  end
end
