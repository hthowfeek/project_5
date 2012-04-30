class SessionsController < ApplicationController
  def new
	@title = "Sign in"
  end
  
  def create
	host = Host.authenticate(params[:session][:email], params[:session][:password])
	
	if host.nil?
		@title = "Sign in"
		render 'new'
		#flash.now[:error] = "Invalid email/password combination"
	else
		sign_in host
		redirect_back_or host
	end
  end
  
  def destroy
	sign_out
	redirect_to root_path
  end 
  
end
