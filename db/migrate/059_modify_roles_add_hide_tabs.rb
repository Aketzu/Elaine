class ModifyRolesAddHideTabs < ActiveRecord::Migration
  def self.up
    add_column :roles, :hide_tabs, :string

    guest = Role.find(1) # if any need to change at all
    guest.hide_tabs = "fileinfo other desc"
    guest.save

    admin = Role.find(2) # if any need to change at all
    admin.hide_tabs = ""
    admin.save

    user = Role.find(3)
    user.hide_tabs = "fileinfo other desc"
    user.save

    toimittaja = Role.find(4)
    toimittaja.hide_tabs = "fileinfo"
    toimittaja.save

    taivas = Role.find(5)
    taivas.hide_tabs = "fileinfo other desc"
    taivas.save

    vod = Role.find(6)
    vod.hide_tabs = "fileinfo other desc"
    vod.save

    editoija = Role.find(7)
    editoija.hide_tabs = "desc"
    editoija.save
  end

  def self.down
    remove_column :roles, :hide_tabs
  end
end
