class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.column :length,	              :integer
      t.column :notes,                :text
      t.column :min_show,             :integer
      t.column :max_show,             :integer
      t.column :do_vod,               :boolean
      t.column :created_on,           :timestamp
      t.column :updated_on,           :timestamp
      t.column :preview_image_offset, :integer
      t.column :preview_video_offset, :integer
      t.column :owner_id,             :integer
      t.column :status_id,            :integer,  :default => ProgramStatus.find(:first, :conditions => [ "name = ?",'Planning' ]).id
      # t.column :name, :string
    end

    execute "ALTER TABLE programs ADD CONSTRAINT owner FOREIGN KEY
    (owner_id) REFERENCES users (id);"
    execute "ALTER TABLE programs ADD CONSTRAINT status FOREIGN KEY
    (status_id) REFERENCES program_statuses (id);"
  end

  def self.down
    execute "ALTER TABLE programs DROP CONSTRAINT owner;"
    execute "ALTER TABLE programs DROP CONSTRAINT status;"
    drop_table :programs
  end
end
