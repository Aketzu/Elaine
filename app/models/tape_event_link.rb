class TapeEventLink < ActiveRecord::Base
  include TimeHelper

belongs_to :Tape
belongs_to :Event

validates_associated :Tape
validates_associated :Event

def formatted_offset
  format_length(offset)
end

def formatted_offset=(formatted)
  self.offset = parse_formatted_length(formatted)
end

end
