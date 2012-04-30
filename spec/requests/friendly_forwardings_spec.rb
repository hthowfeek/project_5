require 'spec_helper'

describe "FriendlyForwardings" do

	it "should forward to the requested page after signin" do
		host = FactoryGirl.create(:host)
		visit edit_host_path(host)
		# The test automatically follows the redirect to the signin page.
		fill_in :email, :with => host.email
		fill_in :password, :with => host.password
		click_button
		# The test follows the redirect again, this time to hosts/edit.
		response.should render_template('hosts/edit')
	end
end 