class AddAdminToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :admin, :boolean

  end
end
