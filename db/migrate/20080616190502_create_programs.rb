class CreatePrograms < ActiveRecord::Migration
  def self.up
    create_table :programs do |t|
      t.integer :program_category_id
      t.integer :program_id
      t.integer :owner_id
      t.string :status
      t.string :programtype
      t.text :notes
      t.datetime :quarantine
      t.string :filename
      t.boolean :file_exists
      t.boolean :file_status_updated
      t.string :file_aspect
      t.integer :file_resx
      t.integer :file_resy
      t.integer :file_length
      t.integer :target_length
      t.integer :pms_id
      t.integer :preview_image_offset
      t.boolean :do_vod
      t.boolean :hidden

      t.timestamps
    end
		add_index :programs, :pms_id
		add_index :programs, :do_vod
		add_index :programs, :program_category_id
		add_index :programs, :program_id
		add_index :programs, :owner_id
  end

  def self.down
    drop_table :programs
  end
end
