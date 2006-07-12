class CreateTapeCategories < ActiveRecord::Migration
  def self.up
    create_table :tape_categories do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end
    TapeCategory.create(
    :name => 'Reference', 
    :description => %{
      Reference tape
    })
    TapeCategory.create(
    :name => 'Master', 
    :description => %{
      Master tape
    })
  end

  def self.down
    drop_table :tape_categories
  end
end
