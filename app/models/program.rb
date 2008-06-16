class Program < ActiveRecord::Base
	belongs_to :program_category

	has_many :program_descriptions
	has_many :playlists
	has_and_belongs_to_many :tapes
	has_many :vods
	has_and_belongs_to_many :users
end
