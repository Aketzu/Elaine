class Tape < ActiveRecord::Base
	has_many :reference_logs
	has_many :programs_tapes
	has_many :programs, :through => :programs_tapes

end
