class CreateProgramStatuses < ActiveRecord::Migration
  def self.up
    create_table :program_statuses do |t|
      # t.column :name, :string
      t.column :name, :string
      t.column :description, :text
    end
    ProgramStatus.create(
    :name => 'Planning',
    :description => %{ Planning ongoing. })
    ProgramStatus.create(
    :name => 'Production',
    :description => %{ In production. })
    ProgramStatus.create(
    :name => 'Complete',
    :description => %{ Program has been completed. })
  end

  def self.down
    drop_table :program_statuses
  end
end
