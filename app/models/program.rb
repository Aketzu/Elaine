class Program < ActiveRecord::Base
	acts_as_tree :foreign_key => :program_id, :include => :program_descriptions
	belongs_to :program_category
	belongs_to :owner, :class_name => "User"

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

	def title
		program_descriptions.first.title
	end

	def tooltip
		title + " " + formatted_length + "<br />" + programtype
	end


	def to_s
		"[" + created_at.year.to_s + "] " + title
	end



	def timesize(secs)
		secs ||= 0
		"%02d:%02d:%02d" % [ secs/3600, secs/60%60, secs%60 ]
	end
	def untimesize(str) 
		secs = 0
		str.split(":").each { |p|
			secs *= 60
			secs += p.to_i
		}
		secs
	end

	def file_length_time
		timesize(file_length)
	end

	def formatted_length
		#TODO: get from subprog lengths...
		timesize(target_length)
	end

	def formatted_target_length
		timesize(target_length)
	end

	def formatted_target_length=(formatted)
	  self.target_length = untimesize(formatted)
	end

	def formatted_preview_image_offset
		timesize(preview_image_offset)
	end
	def formatted_preview_image_offset=(formatted)
	  self.preview_image_offset = untimesize(formatted)
	end


	def full_filename
		#FIXME
		filename
	end

	def length
		#FIXME
		target_length
	end

	named_scope :roots, :conditions => {:program_id => nil}
	named_scope :children_of, lambda { |prog| { :conditions => { :program_id => prog } } }
end
