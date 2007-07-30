class VideoFormat < ActiveRecord::Base

has_many :Vods
has_many :vod_group_format_links
has_and_belongs_to_many :VodGroups, :join_table => :vod_group_format_links
has_many :Programs
# Doesn't work like this (ignores link)
#has_many :Programs, :through => :VodGroups


	def == (other)
		return super(other) if other.is_a? VideoFormat
		return self.id == other if other.is_a?(String) || other.is_a?(Integer)
		return false
	end


end
