class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.column :notes,                :text
      t.column :min_show,             :integer
      t.column :max_show,             :integer
      t.column :do_vod,               :boolean
      t.column :created_at,           :timestamp
      t.column :updated_at,           :timestamp
      t.column :preview_image_offset, :integer
      t.column :preview_video_offset, :integer
      t.column :owner_id,             :integer
      t.column :status_id,            :integer,  :default => ProgramStatus.find(:first, :conditions => [ "name = ?",'Planning' ]).id
      t.column :filename,         :string
      t.column :file_location_id,     :integer
      # t.column :name, :string
    end

    execute "ALTER TABLE programs ADD CONSTRAINT owner FOREIGN KEY
    (owner_id) REFERENCES users (id);"
    execute "ALTER TABLE programs ADD CONSTRAINT status FOREIGN KEY
    (status_id) REFERENCES program_statuses (id);"
    execute "ALTER TABLE programs ADD CONSTRAINT file_location FOREIGN KEY
    (file_location_id) REFERENCES file_locations (id);"
  end

  def self.down
    execute "ALTER TABLE programs DROP CONSTRAINT owner;"
    execute "ALTER TABLE programs DROP CONSTRAINT status;"
    execute "ALTER TABLE programs DROP CONSTRAINT file_location;"
    drop_table :programs
  end
end
