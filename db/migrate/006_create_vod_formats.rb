class CreateVodFormats < ActiveRecord::Migration
  def self.up
    create_table :vod_formats do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
      t.column :vcodec, :string
      t.column :acodec, :string
      t.column :container, :string
      t.column :vbitrate, :integer
      t.column :abitrate, :integer
      t.column :width, :integer
      t.column :height, :integer
      t.column :framerate, :integer
    end
  end

  def self.down
    drop_table :vod_formats
  end
end
