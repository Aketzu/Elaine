class CreateTapes < ActiveRecord::Migration
  def self.up
    create_table :tapes do |t|
      # t.column :name, :string
      t.column :code,        :string
      t.column :title,       :text
      t.column :length,      :integer
      t.column :owner_id,    :integer
      t.column :media_id,    :integer, :default => TapeMedia.find(:first, :conditions => [ "name = ?",'miniDV' ]).id
      t.column :category_id, :integer, :default => TapeCategory.find(:first, :conditions => [ "name = ?", 'Reference' ]).id
    end

    execute "ALTER TABLE tapes ADD CONSTRAINT category FOREIGN KEY
    (category_id) REFERENCES tape_categories (id);"
    execute "ALTER TABLE tapes ADD CONSTRAINT media FOREIGN KEY
    (media_id) REFERENCES tape_medias (id);"
    execute "ALTER TABLE tapes ADD CONSTRAINT owner FOREIGN KEY
    (owner_id) REFERENCES users (id);"
  end

  def self.down
    execute "ALTER TABLE tapes DROP CONSTRAINT owner;"
    execute "ALTER TABLE tapes DROP CONSTRAINT media;"
    execute "ALTER TABLE tapes DROP CONSTRAINT category;"
    drop_table :tapes
  end
end
