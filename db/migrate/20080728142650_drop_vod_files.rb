class DropVodFiles < ActiveRecord::Migration
  def self.up
		drop_table :vod_files
  end

  def self.down
		raise ActiveRecord::IrreversibleMigration, "Cant recover deleted table"
  end
end
