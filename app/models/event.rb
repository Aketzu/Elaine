class Event < ActiveRecord::Base
  include TimeHelper

belongs_to :Location
belongs_to :EventType

has_many :TapeEventLinks
has_many :Tapes, :through => :TapeEventLinks

validates_associated :Location
validates_associated :EventType

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

end
