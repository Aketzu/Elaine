require 'set'

class AccountController < ApplicationController

  skip_before_filter :login_required, :only => ['signup', 'change_password', 'login']
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      get_user_tab_filter
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully as " + self.current_user.login

			#cleanup old sessions
			ActiveRecord::Base.connection.execute "delete from sessions where updated_at < now() - interval '60 minute'"

		else
			flash[:error] = "Invalid username or password. Note that username IS case sensitive."
    end
  end

  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    #redirect_back_or_default(:controller => '/account', :action => 'index')
		redirect_to('/')
  end
	
  def change_password
		@user = User.find(:first, :conditions => ['salt = ?', params[:auth_token]])
		if @user.nil?
			@authenticated = false
			flash[:notice] = "Wrong authentication"
			return
		else
			@authenticated = params[:auth_token]
			
			return unless request.post?
			
			if (params[:password] == params[:password_confirmation])
				@user.password_confirmation = params[:password_confirmation]
				@user.password = params[:password]
				@user.salt = ""
				flash[:notice] = @user.save ?
							"Password changed" :
							"Password not changed"
				redirect_to :action => 'login'
			else
				flash[:notice] = "Password mismatch"
				@old_password = params[:old_password]
			end
		end
  end
	
	private
		def get_user_tab_filter
			if (self.current_user && self.current_user.roles)
				first = self.current_user.roles[0].hide_tabs.to_set
				
				self.current_user.roles.collect do |r|
					first = (first & r.hide_tabs.to_set)
				end
			end
			
			session[:tabs_filter] = first.to_a.join(" ")
		end
end
