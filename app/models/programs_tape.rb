class ProgramsTape < ActiveRecord::Base
	belongs_to :program
	belongs_to :tape
end
