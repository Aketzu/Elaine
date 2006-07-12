class Event < ActiveRecord::Base

belongs_to :Location
belongs_to :EventType

has_many :TapeEventLinks
has_many :Tapes, :through => :TapeEventLinks

validates_associated :Location
validates_associated :EventType

end
