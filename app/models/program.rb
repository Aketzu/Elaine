# encoding: ASCII-8BIT
class Program < ActiveRecord::Base
	#acts_as_tree :foreign_key => :program_id, :include => :program_descriptions

	belongs_to :program_category
	belongs_to :owner, :class_name => "User"

	has_many :program_descriptions
	has_many :playlists
	has_many :programs_taps
	has_many :tapes, :through => :programs_tapes
	has_many :vods
	has_many :programs_users
	has_many :users, :through => :programs_users
	has_many :runlists, :order => :position

	has_many :children, :through => :programs_programs, :source => :subprogram, :order => :position
	has_many :parents, :through => :programs_programs, :source => :program
	has_many :programs_programs
	
	named_scope :roots, :conditions => {:program_id => nil}
	named_scope :children_of, lambda { |prog| { :conditions => { :program_id => prog } } }
	
	named_scope :to_vod, :conditions => {:file_exists => true, :do_vod => true}

	def self.ProgramStatusList
		["Planning", "Production", "Ready for showing", "Done"]
	end

	def self.ProgramTypeList
		["Insert", "Insert+Live", "Live"]
	end

  def self.VodStatusList
    # 0                 1                   2           3                4                      5
    ["No source data", "Waiting encoding", "Encoding", "Encoding done", "Youtube upload done", "All done"]
  end

	def title
		lang = program_descriptions.first.lang
		return program_descriptions.first.title if lang == "en"
		return program_descriptions.last.title if lang != "en"
	end
	def description
		lang = program_descriptions.first.lang
		return program_descriptions.first.description if lang == "en"
		return program_descriptions.last.description if lang != "en"
	end

	def tooltip
		title + " " + formatted_length + "<br />" + programtype
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


	def to_s
		"[" + created_at.year.to_s + "] " + title
	end




	def file_length_time
		timesize(file_length)
	end

	def formatted_length
		timesize(file_length)
	end
	
	def total_length
		len = length
		len ||= 0
		children.each { |ch|
			next if ch.length.nil?
			len += ch.length
		}
		len
	end
	def formatted_total_length
		timesize(total_length)
	end

	def formatted_target_length
		timesize(target_length)
	end
	def total_target_length
		len = target_length
		len ||= 0
		children.each { |ch|
			next if ch.target_length.nil?
			len += ch.target_length
		}
		len
	end
	def formatted_total_target_length
		timesize(total_target_length)
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
		return "" if id.nil? or !filename
		id.to_s + "_" + filename
	end
	def guess_filename
    fn = filename
    fn = title if fn==""

    ch = ProgramsProgram.find(:all, :conditions => "subprogram_id = #{id}", :include => [:program])
    if ch.first
      pp = ch.first.program
      fn = pp.title.gsub(/(demo )?(compo|intro)/i, "") + "_" + fn
    end

    fn.gsub!(/ /, "_")
    fn.gsub!(/[^A-Z0-9a-z_.-]/, "")
    fn.gsub!(/_-_/, "_")
    fn.gsub!(/__+/, "_")

		id.to_s + "_" + fn
	end

	def length
		#FIXME
		file_length || 0
	end

end
