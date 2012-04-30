require 'spec_helper'

describe Party do
  before(:each)do
	@host = FactoryGirl.create(:host)
	@attr = {:name => "PARTAY!"}
  end
  
  it "should create a new instance given valid attributes"do
	@host.parties.create!(@attr)
  end
  
  describe "host associations" do
	before (:each) do
		@party = @host.parties.create(@attr)
	end
	
	it "should have a host attribute" do
		@party.should respond_to(:host)
	end
	
	it "should have the right associated user" do
		@party.host_id.should == @host.id
		@party.host.should == @host		
	end
  end
  
  describe "validations" do
  
	it "should require a host id" do
		Party.new(@attr).should_not be_valid
	end
	
	it "should require nonblank name" do
		@host.parties.build(:name => "  ").should_not be_valid
	end
	
	it "should reject long name" do
		@host.parties.build(:name => "a"*50).should_not be_valid
	end
  end
  
  
  
end #big end