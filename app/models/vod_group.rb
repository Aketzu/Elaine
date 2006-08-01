class VodGroup < ActiveRecord::Base

has_many :Programs
has_many :vod_group_format_links
has_many :VodFormats, :through => :vod_group_format_links

validates_uniqueness_of(:name, :message => "is already in use")

end
