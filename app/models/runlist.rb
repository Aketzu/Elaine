class Runlist < ActiveRecord::Base
	belongs_to :program
	acts_as_list :scope => :program

	def formatted_length=(formatted)
	  self.length = untimesize(formatted)
	end
	def formatted_length
	  timesize(length)
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
end
