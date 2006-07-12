class TapeProgramLink < ActiveRecord::Base

belongs_to :Tape
belongs_to :Program

validates_associated :Tape
validates_associated :Program

end
