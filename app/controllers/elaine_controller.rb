class ElaineController < ApplicationController

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
  
  def new_ticket
    redirect_to "https://bugs.nodeta.fi/trac/elaine/newticket"
  end

  def view_tickets
    redirect_to "https://bugs.nodeta.fi/trac/elaine/report/1?sort=created&asc=1"
  end

end
