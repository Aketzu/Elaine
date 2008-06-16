class Vod < ActiveRecord::Base
	belongs_to :program
	belongs_to :vod_format
end
