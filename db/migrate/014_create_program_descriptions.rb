class CreateProgramDescriptions < ActiveRecord::Migration
  def self.up
    create_table :program_descriptions do |t|
      # t.column :name, :string
      t.column :private_description, :text
      t.column :public_description,  :text
      t.column :title,               :string
      t.column :program_id,          :integer
      t.column :language_id,         :integer, :default => Language.find(:first, :conditions => [ "name = ?",'English' ]).id
    end

    execute "ALTER TABLE program_descriptions ADD CONSTRAINT program FOREIGN KEY
    (program_id) REFERENCES programs (id);"
    execute "ALTER TABLE program_descriptions ADD CONSTRAINT language FOREIGN KEY
    (language_id) REFERENCES languages (id);"
  end

  def self.down
    execute "ALTER TABLE program_descriptions DROP CONSTRAINT program;"
    execute "ALTER TABLE program_descriptions DROP CONSTRAINT language;"
    drop_table :program_descriptions
  end
end
