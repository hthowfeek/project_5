require 'spec_helper'

describe Host do
    before(:each) do
	@attr = { 	:first_name => "Example",
				:last_name => "host", 
				:email => "host@example.com", 
				:username => "exampleuser", 
				:password => "foobar",
				:password_confirmation => "foobar"	}				
	end
	
  it "should create a new instance given valid attributes" do
	Host.create!(@attr)
  end
  
  it "should require a name" do
	no_name_host = Host.new(@attr.merge(:first_name => "",:last_name => ""))
	no_name_host.should_not be_valid	
  end
  
  it "should require an email address" do
	no_email_host = Host.new(@attr.merge(:email => ""))
	no_email_host.should_not be_valid	
  end
  
  it "should reject names that are too long" do
	long_name = "a"*51
	long_name_host = Host.new(@attr.merge(:first_name => long_name, :last_name => long_name))
	long_name_host.should_not be_valid	
  end
  
  it "should accept valid email addresses" do
      addresses = %w[host@foo.com A_HOST@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |address|
        valid_email_host = Host.new(@attr.merge(:email => address))
        valid_email_host.should be_valid
      end      
  end
  
  it "should not accept invalid email addresses" do
      addresses = %w[host@foo,com host_at_foo.org example.host@foo.]
      addresses.each do |address|
        invalid_email_host = Host.new(@attr.merge(:email => address))
        invalid_email_host.should_not be_valid
      end      
  end
  
  it "should reject duplicate email addresses" do
	Host.create!(@attr)
	host_with_duplicate_email = Host.new(@attr)
	host_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
	upcased_email = @attr[:email].upcase
	Host.create!(@attr.merge(:email => upcased_email))
	host_with_duplicate_email = Host.new(@attr)
	host_with_duplicate_email.should_not be_valid
  end
  
  describe "password validations" do
  
	it "should require a password" do
		Host.new(@attr.merge(:password => "", :password_confirmation => "")).
		should_not be_valid
	end
	
	it "should require a matching password confirmation" do
		Host.new(@attr.merge(:password_confirmation => "invalid")).
		should_not be_valid
	end
	
	it "should reject short passwords" do
		short = "a" * 5
		hash = @attr.merge(:password => short, :password_confirmation => short)
		Host.new(hash).should_not be_valid
	end
	
	it "should reject long passwords" do
		long = "a" * 41
		hash = @attr.merge(:password => long, :password_confirmation => long)
		Host.new(hash).should_not be_valid
	end
  end
  
  describe "password encryption" do
	before(:each) do
		@host = Host.create!(@attr)
	end
	
	it "should have an encrypted password attribute" do
		@host.should respond_to(:encrypted_password)
	end
	
	it "should set the encrypted password" do
		@host.encrypted_password.should_not be_blank
	end
	
	describe "has_password? method" do
	
		it "should be true if the passwords match" do
			@host.has_password?(@attr[:password]).should be_true
		end
		
		it "should be false if the passwords don't match" do
			@host.has_password?("invalid").should be_false
		end
		
	end #end of has password? 
	
	describe "authenticate method" do
	
		it "should return nil on email/password mismatch" do
			wrong_password_host = Host.authenticate(@attr[:email], "wrongpass")
			wrong_password_host.should be_nil
		end
		
		it "should return nil for an email address with no host details" do
			nonexistent_host = Host.authenticate("bar@foo.com", @attr[:password])
			nonexistent_host.should be_nil
		end
		
		it "should return the host on email/password match" do
			matching_host = Host.authenticate(@attr[:email], @attr[:password])
			matching_host.should == @host
		end
	end #end of authenticate password
  end # end of password encryption
  
  describe "party associations" do
	before(:each) do
		@host = Host.create(@attr)
		@mp1 = FactoryGirl.create(:party, :host => @host, :created_at => 1.day.ago)
		@mp2 = FactoryGirl.create(:party, :host => @host, :created_at => 1.hour.ago)
	end
	
	it "should have a parties attribute" do
		@host.should respond_to(:parties)
	end
	
	it "should have the right parties in the right order" do
		@host.parties.should == [@mp2, @mp1]
	end
	
	it "should destroy associated parties" do
		@host.destroy
		[@mp1, @mp2].each do |party|
			Party.find_by_id(party.id).should be_nil
		end
	end
	
  end

end #end of describe host
