class AdminController < ApplicationController
  sidebar :general

  def index
    render :action => 'index'
  end

end
