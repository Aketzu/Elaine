class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end

    Channel.create(
    :name => 'AssemblyTV 2006',
    :description => %{ AssemblyTV 2006 })
  end

  def self.down
    drop_table :channels
  end
end
