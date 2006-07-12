class Vod < ActiveRecord::Base

belongs_to :Program
belongs_to :VodFormat

validates_associated :Program
validates_associated :VodFormat

end
