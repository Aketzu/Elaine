class ModifyUsersAaa < ActiveRecord::Migration
  def self.up
    remove_column :users, :role
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
    add_column :users, :role, :string
    add_column :users, :logged_in_at, :datetime
    add_column :users, :deleted, :integer, :default => 0
    add_column :users, :delete_after, :datetime
    add_column :users, :security_token, :string, :limit => 40
    add_column :users, :token_expiry, :datetime
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at
    rename_column :users, :crypted_password, :salted_password
  end
end
