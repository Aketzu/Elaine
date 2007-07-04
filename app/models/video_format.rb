class VodFormat < ActiveRecord::Base

has_many :Vods
has_many :vod_group_format_links
has_many :VodGroups, :through => :vod_group_format_links
# Doesn't work like this (ignores link)
#has_many :Programs, :through => :VodGroups

end
