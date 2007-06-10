# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
#require 'login_engine'



class ApplicationController < ActionController::Base
#sets up acts as authenticated
include AuthenticatedSystem
  helper SimpleSidebarHelper
  include SimpleSidebar
#  include LoginEngine
#  include UserEngine

#  helper :user
#  model :user

#  before_filter :authorize_action
before_filter :login_required

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
