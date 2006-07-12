class TapeEventLink < ActiveRecord::Base

belongs_to :Tape
belongs_to :Event

validates_associated :Tape
validates_associated :Event

end
