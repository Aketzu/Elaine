class Playlist < ActiveRecord::Base

belongs_to :Program
belongs_to :Channel

validates_associated :Program
validates_associated :Channel

end
