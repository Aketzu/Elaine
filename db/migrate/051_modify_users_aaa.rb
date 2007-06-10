class ModifyUsersAaa < ActiveRecord::Migration
  def self.up
    remove_column :users, :logged_in_at
    remove_column :users, :deleted
    remove_column :users, :delete_after
    remove_column :users, :security_token
    remove_column :users, :token_expiry
    add_column :users, :remember_token, :string
    add_column :users, :remember_token_expires_at, :datetime
    rename_column :users, :salted_password, :crypted_password
  end

  def self.down
    add_column :users, :logged_in_at
    add_column :users, :deleted
    add_column :users, :delete_after
    add_column :users, :security_token
    add_column :users, :token_expiry
    remove_column :users, :remember_token, :string
    remove_column :users, :remember_token_expires_at, :datetime
    rename_column :users, :crypted_password, :salted_password
  end
end

#original
#    create_table "users", :force => true do |t|
#      t.column :login,                     :string
#      t.column :email,                     :string
#      t.column :crypted_password,          :string, :limit => 40
#      t.column :salt,                      :string, :limit => 40
#      t.column :created_at,                :datetime
#      t.column :updated_at,                :datetime
#      t.column :remember_token,            :string
#      t.column :remember_token_expires_at, :datetime
#    end
