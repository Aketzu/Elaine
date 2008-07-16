class ProgramDescription < ActiveRecord::Base
	belongs_to :program

	def self.Languages
		{"fi" => "Finnish", "en" => "English"}
	end

	def self.Defaults
		[ ProgramDescription.new(:lang => "en"), ProgramDescription.new(:lang => "fi") ]
	end
end
