class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :title,            :string
      t.column :script,           :text
      t.column :location_id,      :integer, :default => Location.find(:first, :conditions => [ "name = ?",'none' ]).id
      t.column :event_type_id,    :integer
      t.column :notes,            :text
      t.column :length,           :integer
      t.column :quarantine,       :timestamp
      t.column :created_at,       :timestamp
      t.column :updated_at,       :timestamp
      t.column :filename,         :string
      t.column :file_location_id, :integer
      # t.column :name, :string
    end

    execute "ALTER TABLE events ADD CONSTRAINT location FOREIGN KEY
    (location_id) REFERENCES locations (id);"
    execute "ALTER TABLE events ADD CONSTRAINT event_type FOREIGN KEY
    (event_type_id) REFERENCES event_types (id);"
    execute "ALTER TABLE events ADD CONSTRAINT file_location FOREIGN KEY
    (file_location_id) REFERENCES file_locations (id);"
  end

  def self.down
    execute "ALTER TABLE events DROP CONSTRAINT location;"
    execute "ALTER TABLE events DROP CONSTRAINT event_type;"
    execute "ALTER TABLE events DROP CONSTRAINT file_location;"
    drop_table :events
  end
end
