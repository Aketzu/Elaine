# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include LoginEngine
  include UserEngine
  include TimeHelper
  include MenuHelper

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
