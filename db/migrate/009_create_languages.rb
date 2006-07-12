class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      # t.column :name, :string
      t.column :name, :string
    end
    Language.create(
    :name => 'English')

  end

  def self.down
    drop_table :languages
  end
end
