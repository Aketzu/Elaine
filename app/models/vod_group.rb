class VodGroup < ActiveRecord::Base

has_many :ProgramCategories
has_many :vod_group_format_links
has_and_belongs_to_many :VideoFormats, :join_table => :vod_group_format_links

validates_uniqueness_of(:name, :message => "is already in use")

end
