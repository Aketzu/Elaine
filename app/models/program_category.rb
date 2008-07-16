class ProgramCategory < ActiveRecord::Base
	has_many :program

	def self.SelectList
		find(:all, :order => 'name').collect {|t| [ t.name, t.id ] }
	end
end
