class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :username

      t.timestamps
    end
  end
end
