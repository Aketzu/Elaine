class AddDefaultUsers < ActiveRecord::Migration
  def self.up
		u = User.new
		u.login = "admin"
		u.name = "Admin"
		u.email = "anssi@aketzu.net"
		u.password = u.password_confirmation = "password"
		u.save!

  end

  def self.down
		User.delete(User.find_by_login("admin").id)
  end
end
