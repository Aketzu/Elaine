class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :code, :string
      t.column :compulsory, :boolean, :default => true
    end
    Language.create(
    :name => 'English', :code => 'en', :compulsory => true)
    Language.create(
    :name => 'Finnish', :code => 'fi', :compulsory => true)

  end

  def self.down
    drop_table :languages
  end
end
