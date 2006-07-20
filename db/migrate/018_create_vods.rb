class CreateVods < ActiveRecord::Migration
  def self.up
    create_table :vods do |t|
      # t.column :name, :string
      t.column :filename,         :string
      t.column :file_location_id, :integer
      t.column :length,           :integer
      t.column :filesize,         :integer
      t.column :vcodec,           :string
      t.column :avodec,           :string
      t.column :container,        :string
      t.column :vbitrate,         :integer
      t.column :abitrate,         :integer
      t.column :width,            :integer
      t.column :height,           :integer
      t.column :created_at,	  :timestamp
      t.column :updated_at,       :timestamp
      t.column :program_id,       :integer
    end

    execute "ALTER TABLE vods ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
    execute "ALTER TABLE vods ADD CONSTRAINT file_location FOREIGN KEY
    (file_location_id) REFERENCES file_locations (id);"
  end

  def self.down
    execute "ALTER TABLE vods DROP CONSTRAINT program;"
    execute "ALTER TABLE vods DROP CONSTRAINT file_location;"
    drop_table :vods
  end
end
