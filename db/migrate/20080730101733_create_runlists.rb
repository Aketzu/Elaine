class CreateRunlists < ActiveRecord::Migration
  def self.up
    create_table :runlists do |t|
      t.integer :program_id
      t.integer :position
      t.string :source
      t.text :video
      t.text :audio
      t.text :content
      t.integer :length
      t.text :info

      t.timestamps
    end

		add_index :runlists, :program_id

		foreign_key :runlists, :program_id, :delete => 'CASCADE'
  end

  def self.down
		drop_foreign_key :runlists, :program_id
    drop_table :runlists
  end
end
