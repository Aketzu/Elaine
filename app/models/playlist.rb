class Playlist < ActiveRecord::Base
	belongs_to :channel
	belongs_to :program
	
	named_scope :for_channel, lambda { |ch| { :conditions => { :channel_id => ch } } }

	def end_time
		ret ||= start_at + program.length
		ret ||= start_at
		ret
	end
end
