class AddSaltToHosts < ActiveRecord::Migration
  def change
    add_column :hosts, :salt, :string

  end
end
