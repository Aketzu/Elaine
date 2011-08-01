class AddTechnicalChecklistToPrograms < ActiveRecord::Migration
  def self.up
    add_column :programs, :mcu_auxout, :string
    add_column :programs, :mcu_auxres, :string
    add_column :programs, :mcu_studiolaptop, :boolean
    add_column :programs, :mcu_hallpgm, :boolean
    add_column :programs, :mcu_stagepic, :boolean
    add_column :programs, :mcu_recorded, :boolean
    add_column :programs, :mcu_hastg, :boolean
    add_column :programs, :cam_studio, :integer
    add_column :programs, :cam_foh, :integer
    add_column :programs, :cam_stage, :integer
    add_column :programs, :is_broadcast, :boolean
    add_column :programs, :bu_recorded, :boolean
    add_column :programs, :hall_stagepic, :boolean
    add_column :programs, :hall_bupgm, :boolean
    add_column :programs, :hall_mcuaux, :boolean
    add_column :programs, :hall_sauna, :integer
    add_column :programs, :stage_mcuaux, :boolean
    add_column :programs, :stage_output, :string
  end

  def self.down
    remove_column :programs, :stage_output
    remove_column :programs, :stage_mcuaux
    remove_column :programs, :hall_sauna
    remove_column :programs, :hall_mcuaux
    remove_column :programs, :hall_bupgm
    remove_column :programs, :hall_stagepic
    remove_column :programs, :bu_recorded
    remove_column :programs, :is_broadcast
    remove_column :programs, :cam_stage
    remove_column :programs, :cam_foh
    remove_column :programs, :cam_studio
    remove_column :programs, :mcu_hastg
    remove_column :programs, :mcu_recorded
    remove_column :programs, :mcu_stagepic
    remove_column :programs, :mcu_hallpgm
    remove_column :programs, :mcu_studiolaptop
    remove_column :programs, :mcu_auxres
    remove_column :programs, :mcu_auxout
  end
end
