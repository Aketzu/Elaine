class ProgramsProgram < ActiveRecord::Base
	belongs_to :program
	belongs_to :subprogram, :class_name => 'Program'
	acts_as_list :scope => :program
end
