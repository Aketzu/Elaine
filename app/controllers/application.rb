# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
#sets up acts as authenticated

  include UserEngine
  include AuthenticatedSystem

  #helper SimpleSidebarHelper

	before_filter :login_required
  before_filter :login_from_cookie

  before_filter :require_ssl if (RAILS_ENV == "production")
		# && !["vod", "vod_formats"].include?(params[:controller])

  def require_ssl
    unless request.ssl?
      redirect_to :protocol => "https://"
    end
  end

  def require_no_ssl
    if request.ssl?
      redirect_to :protocol => "http://"
    end
  end

end
