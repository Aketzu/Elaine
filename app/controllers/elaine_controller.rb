class ElaineController < ApplicationController
  sidebar :general

  before_filter :require_no_ssl if (RAILS_ENV == "production")

  def index
#    @user = params[:user]
#    if User.
#      redirect_to :action => 'admin'
#    end
  end

  def admin
    render :action => 'index'
    render :action => 'admin'
  end
  
  def issues
  end

  def todo
  end

end
