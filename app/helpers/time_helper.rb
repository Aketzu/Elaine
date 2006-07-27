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
    hours = formatted[0,1].to_i
    minutes = formatted[3,4]
    seconds = formatted[6,7]
    if( (not formatted.nil?) && (formatted.length == 8) )
      ((((hours.to_f * 60) + minutes.to_f) * 60) + seconds.to_i).to_i
    else
      nil
    end
  end

end