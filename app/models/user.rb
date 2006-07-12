class User < ActiveRecord::Base

has_many :Tapes
has_many :Programs

end
