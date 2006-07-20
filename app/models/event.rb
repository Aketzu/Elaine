class Event < ActiveRecord::Base
  include TimeHelper

belongs_to :Location
belongs_to :EventType
belongs_to :FileLocation

has_many :tape_event_links, :dependent => :destroy
has_many :Tapes,    :through => :tape_event_links
has_many :program_event_links, :dependent => :destroy
has_many :Programs, :through => :program_event_links

validates_associated :Location
validates_associated :EventType

def formatted_length
  format_length(length)
end

def formatted_length=(formatted)
  self.length = parse_formatted_length(formatted)
end

end
