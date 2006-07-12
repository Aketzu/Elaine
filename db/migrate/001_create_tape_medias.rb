class CreateTapeMedias < ActiveRecord::Migration
  def self.up
    create_table :tape_medias do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end
    TapeMedia.create(
    :name => 'VHS', 
    :description => %{ VHS })
    TapeMedia.create(
    :name => 'miniDV', 
    :description => %{ miniDV })
    TapeMedia.create(
    :name => 'DV', 
    :description => %{ DV })
    TapeMedia.create(
    :name => 'miniDV-DVCAM', 
    :description => %{ miniDV-DVCAM })
    TapeMedia.create(
    :name => 'DVCPRO', 
    :description => %{ DVCPRO })
  end

  def self.down
    drop_table :tape_medias
  end
end
