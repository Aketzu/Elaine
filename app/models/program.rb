class Program < ActiveRecord::Base
	belongs_to :program_category

	has_many :program_descriptions
	has_many :playlists
	has_many :programs_taps
	has_many :tapes, :through => :programs_tapes
	has_many :vods
	has_many :programs_users
	has_many :users, :through => :programs_users

	def self.ProgramStatusList
		["Planning", "Production", "Ready for showing", "Done"]
	end

	def self.ProgramTypeList
		["Insert", "Insert+Live", "Live"]
	end


	def timesize(secs)
		secs ||= 0
		"%02d:%02d:%02d" % [ secs/3600, secs/60%60, secs%60 ]
	end

	def file_length_time
		timesize(file_length)
	end
end
