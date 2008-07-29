class Playlist < ActiveRecord::Base
	belongs_to :channel
	belongs_to :program
	
	named_scope :for_channel, lambda { |ch| { :conditions => { :channel_id => ch } } }

	def end_time
		return 0 if program.nil?
		ret = start_at + program.total_length
	end
end
