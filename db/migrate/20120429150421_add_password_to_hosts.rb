class AddPasswordToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :encrypted_password, :string

  end
end
