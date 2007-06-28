class CreateUserRolesInitialSchema < ActiveRecord::Migration
  def self.up
    create_table :permission_table, :force => true do |t|
      t.column "controller", :string, :default => "", :null => false
      t.column "action", :string, :default => "", :null => false
      t.column "description", :string
    end

    create_table :permission_role_table, :id => false, :force => true do |t|
      t.column "permission_id", :integer, :default => 0, :null => false
      t.column "role_id", :integer, :default => 0, :null => false
    end

    create_table :user_role_table, :id => false, :force => true do |t|
      t.column "user_id", :integer, :default => 0, :null => false
      t.column "role_id", :integer, :default => 0, :null => false
    end

    create_table :role_table, :force => true do |t|
      t.column "name",        :string, :default => "", :null => false
      t.column "description", :string
			t.column "omnipotent",  :boolean, :default => false, :null => false
			t.column "system_role", :boolean, :default => false, :null => false
    end
  end

  def self.down
    drop_table :permission_table
    drop_table :permission_role_table
    drop_table :user_role_table
    drop_table :role_table
  end
end
