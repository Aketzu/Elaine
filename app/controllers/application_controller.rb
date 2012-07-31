# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '078937ff8fa0da0000eacaef19d083d7'


	def indexed_auto_complete_result(entries, entityType, field, index)
		return unless entries
		items = entries.map { |entry| content_tag("li", entry, "id" => entityType+'::'+entry[index].to_s) }
		content_tag("ul", items.uniq)
	end
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
	
	before_filter :login_required
	before_filter :check_auth

	def check_auth
		authorized? || access_denied
	end

	def authorized?(action=nil, resource=nil, *args) 
		return true if self.class.required_level == 0
		if action.is_a? Hash and !action[:controller].nil?
			controller = action[:controller].camelize + "Controller"
			req = eval "#{controller}.required_level"
			return current_user.level >= req
		end
		if action.is_a? Fixnum
			return current_user.level >= action
		end
		return false unless current_user
		return current_user.level >= self.class.required_level
	end

	def self.required_level
		#Default level
		ADMIN
	end

	def require_permission(level)
		(access_denied; return false) unless current_user.level >= level
		return true
	end

	def self.require_permission(level)
		class_eval <<-END
			def self.required_level
				#{level}
			end
		END
	end

  helper_method :format_length, :parse_formatted_length

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
