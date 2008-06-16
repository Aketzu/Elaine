class Tape < ActiveRecord::Base
	has_many :reference_logs
	has_and_belongs_to_many :programs

end
