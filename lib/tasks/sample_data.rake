require 'faker'
namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Host.create!(first_name: "Example User", 
				 last_name: "User", 
				 email: "example@denver.edu", 
				 username: "exampleuser",
				 password: "foobar", 
				 password_confirmation: "foobar" )
	#admin.toggle!(:admin)
	
	99.times do |n|
		first_name = Faker::Name.name
		last_name = Faker::Name.name
		email = "example-#{n+10}@denver.edu"
		password = "password"
		Host.create!( first_name: first_name,
					  last_name: last_name,
					  email: "example@colombo.edu", 
					  username: "exampleuser",
					  password: password,
					  password_confirmation: password)
	end
	
	Host.all(:limit => 6).each do |host|
		50.times do
			host.parties.create!(:name => Faker::Lorem)
		end
	end
	end
end		

			