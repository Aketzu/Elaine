class CreateVodFiles < ActiveRecord::Migration
  def self.up
    create_table :vod_files do |t|
      t.string :filename
      t.string :full_path

      t.timestamps
    end
		add_index :vod_files, :filename
  end

  def self.down
    drop_table :vod_files
  end
end
