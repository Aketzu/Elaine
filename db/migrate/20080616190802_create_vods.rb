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
  end

  def self.down
    drop_table :vods
  end
end
