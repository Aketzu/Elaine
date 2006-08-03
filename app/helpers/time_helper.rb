module TimeHelper

  def format_length(length)
    unless length.nil?
      total_minutes, seconds = length.divmod(60)
      total_hours, minutes   = total_minutes.divmod(60)
      days, hours            = total_hours.divmod(24)
      if(days > 0)
        sprintf("%d day %02d:%02d:%02d", days, hours, minutes, seconds)
      else
        sprintf("%02d:%02d:%02d", hours, minutes, seconds)
      end
    else
      sprintf("")
    end
  end

  def parse_formatted_length(formatted)
    hours = formatted[0,2]
    minutes = formatted[3,2]
    seconds = formatted[6,2]
    if( (not formatted.nil?) && (formatted.length == 8) )
      ((((hours.to_f * 60.0) + minutes.to_f) * 60.0) + seconds.to_i).to_i
    else
      nil
    end
  end

end