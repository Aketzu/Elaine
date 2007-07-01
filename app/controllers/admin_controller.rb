class AdminController < ApplicationController
  sidebar :general
	#observer :admin_mailer

  def index
    render :action => 'index'
  end
	
	def send_change_password_link
		@users = User.find(:all)
		return unless request.post?
		
		params[:sendlink].each do |id|
			email = AdminMailer.deliver_send_change_password_link(User.find(id))
			flash[:notify] = "Links sent succesfully"
		end
	end

  def add_user
    @user = User.new(params[:user])
    return unless request.post?
		@user.generate_password
    if (@user.save!)
			unless AdminMailer.deliver_send_change_password_link(@user)
				flash[:notice] = "Email password could not be sent."
			end
		end
    redirect_back_or_default(:controller => 'user', :action => 'list')
    flash[:notice] = "User added succesfully!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'add_user'
  end
  
end
