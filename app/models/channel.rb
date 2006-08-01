class Channel < ActiveRecord::Base

has_many :BroadcastLogs
has_many :Playlists
has_many :ReferenceLogEntries

validates_uniqueness_of(:name, :message => "is already in use.")

end
