class CreateTapes < ActiveRecord::Migration
  def self.up
    create_table :tapes do |t|
      t.string :code
      t.string :title
      t.integer :length
      t.string :type

      t.timestamps
    end
		add_index :tapes, :type
  end

  def self.down
    drop_table :tapes
  end
end
