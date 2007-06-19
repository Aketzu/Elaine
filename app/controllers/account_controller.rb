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
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    end
  end

  def signup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/account', :action => 'index')
  end
	
  def change_password
		user = User.find(:first, :conditions => ['salt = ?', params[:auth_token]])
		if user.nil?
			@authenticated = false
			flash[:notice] = "Wrong authentication"
			return
		else
			@authenticated = params[:auth_token]
			
			return unless request.post?
			
			if (params[:password] == params[:password_confirmation])
				user.password_confirmation = params[:password_confirmation]
				user.password = params[:password]
				user.salt = ""
				flash[:notice] = user.save ?
							"Password changed" :
							"Password not changed"
			else
				flash[:notice] = "Password mismatch"
				@old_password = params[:old_password]
			end
		end
  end
end
