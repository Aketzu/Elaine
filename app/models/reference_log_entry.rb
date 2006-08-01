class ReferenceLogEntry < ActiveRecord::Base
  include TimeHelper

belongs_to :Channel
belongs_to :Tape

validates_associated :Channel
validates_associated :Tape

  def formatted_start_time
    format_length(start_time)
  end

  def formatted_start_time=(formatted)
    self.start_time = parse_formatted_length(formatted)
  end

  def formatted_end_time
    format_length(end_time)
  end

  def formatted_end_time=(formatted)
    self.end_time = parse_formatted_length(formatted)
  end


end
