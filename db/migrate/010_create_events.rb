class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :title,         :string
      t.column :script,        :text
      t.column :location_id,   :integer, :default => Location.find(:first, :conditions => [ "name = ?",'none' ]).id
      t.column :event_type_id, :integer
      t.column :notes,	       :text
      t.column :length,        :integer
      t.column :quarantine,    :timestamp
      t.column :created,       :timestamp
      t.column :modified,      :timestamp
      # t.column :name, :string
    end

    execute "ALTER TABLE events ADD CONSTRAINT location FOREIGN KEY
    (location_id) REFERENCES locations (id);"
    execute "ALTER TABLE events ADD CONSTRAINT event_type FOREIGN KEY
    (event_type_id) REFERENCES event_types (id);"
  end

  def self.down
    execute "ALTER TABLE events DROP CONSTRAINT location;"
    execute "ALTER TABLE events DROP CONSTRAINT event_type;"
    drop_table :events
  end
end
