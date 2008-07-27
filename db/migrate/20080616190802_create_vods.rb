require 'migration_helpers'

class CreateVods < ActiveRecord::Migration
  def self.up
    create_table :vods do |t|
      t.string :filename
      t.integer :program_id
      t.integer :vod_format_id
      t.integer :filesize
      t.integer :length

      t.timestamps
    end
		add_index :vods, :program_id
		add_index :vods, :filename
		foreign_key :vods, :program_id, :delete => "cascade"
		foreign_key :vods, :vod_format_id, :delete => "cascade"
  end

  def self.down
		drop_foreign_key :vods, :program_id
    drop_table :vods
  end
end
