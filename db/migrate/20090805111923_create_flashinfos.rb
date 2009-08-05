class CreateFlashinfos < ActiveRecord::Migration
  def self.up
    create_table :flashinfos do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
		add_index :flashinfos, :key
  end

  def self.down
    drop_table :flashinfos
  end
end
