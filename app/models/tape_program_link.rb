class TapeProgramLink < ActiveRecord::Base
  include TimeHelper

belongs_to :Tape
belongs_to :Program

validates_associated :Tape
validates_associated :Program

  def formatted_start_time
  format_length(start_time)
  end

  def formatted_start_time=(formatted)
    self.start_time = parse_formatted_length(formatted)
  end

end
