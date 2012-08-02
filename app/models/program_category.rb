class ProgramCategory < ActiveRecord::Base
	has_many :programs

	def self.SelectList
		find(:all, :order => 'name').collect {|t| [ t.name, t.id ] }
	end

  def tag
    name.gsub(/^[0-9]* /, "")
  end
end
