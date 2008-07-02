class AddDefaultProgramCategories < ActiveRecord::Migration
  def self.up
		ProgramCategory.new(:name => "AssemblyTV", :description => "The TV", :default_do_vod => false, :default_hidden => false).save!
		ProgramCategory.new(:name => "Seminars", :description => "Seminars", :default_do_vod => true, :default_hidden => false).save!
		ProgramCategory.new(:name => "Compos", :description => "Demoi ja sillee", :default_do_vod => true, :default_hidden => false).save!
  end

  def self.down
		ProgramCategory.delete(ProgramCategory.find_by_name("AssemblyTV").id)
		ProgramCategory.delete(ProgramCategory.find_by_name("Seminars").id)
		ProgramCategory.delete(ProgramCategory.find_by_name("Compos").id)
  end
end
