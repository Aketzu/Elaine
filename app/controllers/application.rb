# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include AuthenticatedSystem

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '078937ff8fa0da0000eacaef19d083d7'
  
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

	def self.require_permission(level)
		class_eval <<-END
			def self.required_level
				#{level}
			end
		END
	end
end
