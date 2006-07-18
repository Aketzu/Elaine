class TapeEventLink < ActiveRecord::Base
  include TimeHelper

belongs_to :Tape
belongs_to :Event

validates_associated :Tape
validates_associated :Event

def formatted_start_time
 format_length(start_time)
end

def formatted_start_time=(formatted)
  self.start_time = parse_formatted_length(formatted)
end

end
