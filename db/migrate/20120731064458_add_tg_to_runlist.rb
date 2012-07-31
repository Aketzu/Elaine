class AddTgToRunlist < ActiveRecord::Migration
  def self.up
    add_column :runlists, :tg, :text
  end

  def self.down
    remove_column :runlists, :tg
  end
end
