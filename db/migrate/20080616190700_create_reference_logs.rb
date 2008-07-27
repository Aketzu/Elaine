require 'migration_helpers'
class CreateReferenceLogs < ActiveRecord::Migration
  def self.up
    create_table :reference_logs do |t|
      t.integer :channel_id
      t.integer :tape_id
      t.integer :start_at
      t.integer :end_at

      t.timestamps
    end
		add_index :reference_logs, [:channel_id, :tape_id]
		foreign_key :reference_logs, :channel_id, :delete => "cascade"
		foreign_key :reference_logs, :tape_id, :delete => "cascade"
  end

  def self.down
		drop_foreign_key :reference_logs, :channel_id
		drop_foreign_key :reference_logs, :tape_id
    drop_table :reference_logs
  end
end
