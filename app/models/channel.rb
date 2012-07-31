class Channel < ActiveRecord::Base
	has_many :playlists
	has_many :reference_log
end
