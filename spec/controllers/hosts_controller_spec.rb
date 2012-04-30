require 'spec_helper'

describe HostsController do
render_views

describe "GET 'index'" do
		describe "for non-signed-in hosts" do
			it "should deny access" do
			get :index
			redirect_to(signin_path)
			#flash[:notice].should =~ /sign in/i
			end
		end
			
		describe "for signed-in hosts" do
			before(:each) do
			@host = test_sign_in(FactoryGirl.create(:host))
			second = FactoryGirl.create(:host,:first_name => "Bob",  :email => "another@example.com")
			third = FactoryGirl.create(:host, :first_name => "Ben", :email => "another@example.net")
			@hosts = [@host, second, third]
			
		end
		it "should be successful" do
			get :index
			response.should be_success
			end
			it "should have the right title" do
			get :index
			response.should have_selector("title", :content => "All hosts")
			end
			it "should have an element for each host" do
			get :index
			@hosts[0..2].each do |host|
				response.should have_selector("li", :content => host.first_name)
			end
			end
		end
	end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end
	
	it "should have the right title" do
		get 'new'
		response.should have_selector("title",
                        :content => "Sign up")
	end
  end

  describe "GET 'show'" do
	before(:each) do
		@host = FactoryGirl.create(:host)
	end
	
	it "should be successful" do
		get :show, :id => @host
		response.should be_success
	end
	
	it "should find the right host" do
		get :show, :id => @host
		assigns(:host).should == @host
	end
	
	it "should have the right title" do
		get :show, :id => @host
		response.should have_selector("title", :content => @host.last_name)
	end
	
	it "should include the host's name" do
		get :show, :id => @host
		response.should have_selector("h1", :content => @host.last_name)
	end
	
	it "should have a profile image" do
		get :show, :id => @host
		response.should have_selector("h1>img", :class => "gravatar")
	end
	
	it "should show the user's microposts" do
		mp1 = FactoryGirl.create(:party, :host => @host, :name => "Foo bar")
		mp2 = FactoryGirl.create(:party, :host => @host, :name => "Baz quux")
		get :show, :id => @host
		response.should have_selector("span.name", :content => mp1.name)
		response.should have_selector("span.name", :content => mp2.name)
	end
	
  end #end of get show
  
  describe "POST 'create'" do
  
	describe "failure" do
		before(:each) do
		@attr = { :first_name => "",:last_name => "", :email => "", :username => "", :password => "",
		:password_confirmation => "" }
	end
	
	it "should not create a host" do
		lambda do
		post :create, :host => @attr
		end.should_not change(Host, :count)
	end
	
	it "should have the right title" do
		post :create, :host => @attr
		response.should have_selector("title", :content => "Sign up")
	end
	
	it "should render the 'new' page" do
		post :create, :host => @attr
		response.should render_template('new')
	end
	
	#it "should have a flash.now message" do
	#	post :create, :session => @attr
	#	flash.now[:error].should =~ /invalid/i
	#end
end
	
	describe "success" do
		before(:each) do
			@attr = { :first_name => "New",:last_name => "host", :email => "newuser@gmail.com", :username => "newuser", :password => "foobar",
			:password_confirmation => "foobar" }
		end
		
		it "should create a host" do
			lambda do
			post :create, :host => @attr
			end.should change(Host, :count).by(1)
		end
		
		it "should sign the host in" do
			post :create, :host => @attr
			controller.should be_signed_in
		end
		
		it "should redirect to the host show page" do
			post :create, :host => @attr
			response.should redirect_to(host_path(assigns(:host)))
		end
		
		it "should have a welcome message" do
			post :create, :host => @attr
			flash[:success].should =~ /welcome to party planners inc/i
		end
	end #end of describe success
  end #end of post create
  
  describe "GET 'edit'" do
	before(:each) do
	@host = FactoryGirl.create(:host)
	test_sign_in(@host)
	end
	
	it "should be successful" do
	get :edit, :id => @host
	response.should be_success
	end
	
	it "should have the right title" do
	get :edit, :id => @host
	response.should have_selector("title", :content => "Edit host")
	end
  end
  
	describe "PUT 'update'" do
		before(:each) do
		@host = FactoryGirl.create(:host)
		test_sign_in(@host)
		end
		
	describe "failure" do
		before(:each) do
			@attr = { :email => "", :first_name => "", :last_name => "", :username => "",  :password => "",
			:password_confirmation => "" }
			end
			
			it "should render the 'edit' page" do
			put :update, :id => @host, :host => @attr
			response.should render_template('edit')
			end
			
			it "should have the right title" do
			put :update, :id => @host, :host => @attr
			response.should have_selector("title", :content => "Edit host")
			end
		end
		
		describe "success" do
			before(:each) do
			@attr = { :first_name => "New Name",:last_name => "New Name",:username => "NewName", :email => "host@example.org",
			:password => "barbaz", :password_confirmation => "barbaz" }
			end
			
			it "should change the host's attributes" do
			put :update, :id => @host, :host => @attr
			@host.reload
			@host.first_name.should == @attr[:first_name]
			@host.last_name.should == @attr[:last_name]
			@host.email.should == @attr[:email]
			end
			
			it "should redirect to the host show page" do
			put :update, :id => @host, :host => @attr
			response.should redirect_to(host_path(@host))
			end
			
			it "should have a flash message" do
			put :update, :id => @host, :host => @attr
			flash[:success].should =~ /updated/
			end
	end
end

describe "authentication of edit/update pages" do
	before(:each) do
		@host = FactoryGirl.create(:host)
	end
	
	describe "for non-signed-in hosts " do
		it "should deny access to 'edit'" do
		get :edit, :id => @host
		response.should redirect_to(signin_path)
		end
		
		it "should deny access to 'update'" do
		put :update, :id => @host, :host => {}
		response.should redirect_to(signin_path)
		end
	end
	
	describe "for signed-in hosts " do
		before(:each) do
		wrong_host = FactoryGirl.create(:host, :email => "host@example.net")
		test_sign_in(wrong_host)
		end
		
		it "should require matching hosts  for 'edit'" do
		get :edit, :id => @host
		response.should redirect_to(root_path)
		end
		
		it "should require matching hosts  for 'update'" do
		put :update, :id => @host, :host => {}
		response.should redirect_to(root_path)
		end
	end
	
	#it "should paginate hosts" do
	#	get :index
	#	response.should have_selector("div.pagination")
	#	response.should have_selector("span.disabled", :content => "Previous")
	#	response.should have_selector("a", :href => "/?page=2",
	#	:content => "2")
	#	response.should have_selector("a", :href => "/hosts?page=2",
	#	:content => "Next")
	#end
	describe "admin attribute" do
	before(:each) do
	@attr = { 	:first_name => "Example1",
				:last_name => "host1", 
				:email => "host1@example.com", 
				:username => "exampleuser1", 
				:password => "foobar1",
				:password_confirmation => "foobar1"	}
	@host = Host.create!(@attr)
	end
	
	it "should respond to admin" do
	@host.should respond_to(:admin)
	end
	
	it "should not be an admin by default" do
	@host.should_not be_admin
	end
	
	it "should be convertible to an admin" do
	@host.toggle!(:admin)
	@host.should be_admin
	end
	end

describe "DELETE 'destroy'" do
	before(:each) do
	@host = FactoryGirl.create(:host, :email => "testingadminuser@g.com")
	end
	
	describe "as a non-signed-in host" do
		it "should deny access" do
		delete :destroy, :id => @host
		response.should redirect_to(signin_path)
		end
	end
	
	describe "as a non-admin host" do
		it "should protect the page" do
		test_sign_in(@host)
		delete :destroy, :id => @host
		response.should redirect_to(root_path)
		end
	end
	
	describe "as an admin host" do
		before(:each) do
		admin = FactoryGirl.create(:host, :email => "admin@example.com", :admin => true)
		test_sign_in(admin)
	end
	
	it "should destroy the host" do
		lambda do
			delete :destroy, :id => @host
			end.should change(Host, :count).by(-1)
	end
		
	it "should redirect to the hosts page" do
		delete :destroy, :id => @host
		response.should redirect_to(hosts_path)
		end
		end
	end
end
end 
