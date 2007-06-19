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

end
