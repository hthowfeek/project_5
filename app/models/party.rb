class Party < ActiveRecord::Base
	attr_accessible :name, :date, :location, :start_time, :end_time, :desription, :rsvp_date
	belongs_to :host
	
	validates :name, :presence => true, :length => {:maximum => 40}
	validates :host_id, :presence => true
	default_scope :order => 'parties.created_at DESC'
end
