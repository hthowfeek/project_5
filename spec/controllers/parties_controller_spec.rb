require 'spec_helper'

describe PartiesController do
render_views
	
  describe "access control" do
	it "should deny access to 'create'" do
		post :create
		response.should redirect_to(signin_path)
	end
	
	it "should deny access to 'destroy'" do
		delete :destroy, :id => 1
		response.should redirect_to(signin_path)
	end
  end
  
  describe "POST 'create'" do
	before(:each) do
	@host = test_sign_in(FactoryGirl.create(:host))
	end
	
	describe "failure" do
		before(:each) do
		@attr = { :name => "" }
		end
		
		it "should not create a party" do
		lambda do
			post :create, :party => @attr
			end.should_not change(Party, :count)
		end
		
		it "should render the home page" do
			post :create, :party => @attr
			response.should render_template('pages/home')
		end
	end
	
	describe "success" do
		before(:each) do
		@attr = FactoryGirl.create(:party, :email => "party@madness.com")
		end
		
		it "should create a party" do
			lambda do
			post :create, :party => @attr
			end.should change(Party, :count).by(1)
		end
		
		it "should redirect to the home page" do
			post :create, :party => @attr
			response.should redirect_to(root_path)
		end
		
		it "should have a flash message" do
		post :create, :party => @attr
		flash[:success].should =~ /party created/i
		end
	end
  end

	
end #big end
