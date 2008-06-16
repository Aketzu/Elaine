class CreateVodFormats < ActiveRecord::Migration
  def self.up
    create_table :vod_formats do |t|
      t.string :name
      t.string :vcodec
      t.string :acodec
      t.string :container
      t.integer :vbitrate
      t.integer :abitrate
      t.integer :width
      t.integer :height
      t.decimal :framerate
      t.string :mime_type
      t.string :file_extension

      t.timestamps
    end
		add_index :vod_formats, [:width, :height]
  end

  def self.down
    drop_table :vod_formats
  end
end
