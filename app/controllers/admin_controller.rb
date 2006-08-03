class AdminController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  def index
    render :action => 'index'
  end

end
