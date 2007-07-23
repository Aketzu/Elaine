class ModifyRolesAddHideTabs < ActiveRecord::Migration
  def self.up
    add_column :roles, :hide_tabs, :string

    guest = Role.find(1) # if any need to change at all
    guest.hide_tabs = ""
    guest.save

    admin = Role.find(2) # if any need to change at all
    admin.hide_tabs = ""
    admin.save

    user = Role.find(3)
    user.hide_tabs = "fileinfo"
    user.save

    perus = Role.find(4)
    perus.hide_tabs = "fileinfo"
    perus.save

    taivas = Role.find(5)
    taivas.hide_tabs = ""
    taivas.save

    vod = Role.find(6)
    vod.hide_tabs = ""
    vod.save
  end

  def self.down
    remove_column :roles, :hide_tabs
  end
end
