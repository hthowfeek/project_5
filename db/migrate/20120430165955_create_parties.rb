class CreateParties < ActiveRecord::Migration
  def change
    create_table :parties do |t|
      t.integer :host_id
      t.string :name
      t.date :date
      t.string :location
      t.time :start_time
      t.time :end_time
      t.string :desription
      t.date :rsvp_date

      t.timestamps
    end
	add_index :parties, [:host_id, :created_at]
  end
end
