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
  end

  def self.down
    drop_table :reference_logs
  end
end
