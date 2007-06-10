class CreateEventTypes < ActiveRecord::Migration
  def self.up
    create_table :event_types do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end

    EventType.create(
    :name => 'live', 
    :description => %{ Live })
    EventType.create(
    :name => 'insert', 
    :description => %{ Insert })
  end

  def self.down
    drop_table :event_types
  end
end
