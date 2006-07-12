class Channel < ActiveRecord::Base

has_many :BroadcastLogs
has_many :Playlists

end
