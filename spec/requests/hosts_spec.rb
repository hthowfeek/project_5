require 'spec_helper'

describe "Hosts" do
  describe "signup" do
	describe "failure" do
			it "should not make a new host" do
				lambda do
					visit signup_path
					fill_in "First Name", :with => ""
					fill_in "Last Name", :with => ""
					fill_in "Email", :with => ""
					fill_in "Username", :with => ""
					fill_in "Password", :with => ""
					fill_in "Confirmation", :with => ""
					click_button
					response.should render_template('hosts/new')
					response.should have_selector("div", :id => "error explaination")
				end.should_not change(Host, :count)
			end
		end
	
	describe "success" do
			it "should make a new host" do
				lambda do
					visit signup_path
					fill_in "First Name", :with => "Haya"
					fill_in "Last Name", :with => "Thowfeek"
					fill_in "Email", :with => "hayathowfeek@gmail.com"
					fill_in "Username", :with => "hthowfeek"
					fill_in "Password", :with => "test123"
					fill_in "Confirmation", :with => "test123"
					click_button
					response.should have_selector("div.alert.alert-success", :content => "Welcome")
					response.should render_template('hosts/show')
				end.should change(Host, :count).by(1)
			end
	end	
  end #end of describe signup
  describe "sign in/out" do
		describe "failure" do
		
			it "should not sign a host in" do
				visit signin_path
				fill_in :email, :with => ""
				fill_in :password, :with => ""
				click_button "Sign in"
				#response.should have_selector("div.flash.error", :content => "Invalid")
			end
			
		end
		
		describe "success" do
		
			it "should sign a host in and out" do
				host = FactoryGirl.create(:host)
				visit signin_path
				fill_in :email, :with => host.email
				fill_in :password, :with => host.password
				click_button "Sign in"
				controller.should be_signed_in
				click_link "Sign out"
				controller.should_not be_signed_in
			end
		end
	end #end of describe signin/out
end #end of describe hosts

