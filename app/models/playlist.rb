class Playlist < ActiveRecord::Base
	belongs_to :channel
	belongs_to :program
end
