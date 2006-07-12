class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      # t.column :name, :string
      t.column :name,         :string
      t.column :title,        :string
      t.column :organization, :string
      t.column :phone,        :string
      t.column :email,        :string
    end
  end

  def self.down
    drop_table :people
  end
end
