class AdminMailer < ActionMailer::Base
  def send_change_password_link(user)
    @subject    = 'Elaine.assembly.org: Change your password'
    @recipients = user.email
    @from       = 'elaine@assembly.org'
    @sent_on    = Time.now
		@auth_token = user.salt
    @body["auth_token"] = user.salt
  end
end
