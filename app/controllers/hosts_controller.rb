class HostsController < ApplicationController
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_host, :only => [:edit, :update]
  before_filter :admin_user, :only => [:destroy]
  
  def index
	@title = "All hosts"
	@hosts = Host.paginate(:page => params[:page])
  end
  def new
	@host = Host.new
	@title = "Sign up"
  end
  
  def show
	@host = Host.find(params[:id])
	@parties = @host.parties.paginate(page: params[:page])
	@title = @host.first_name, @host.last_name
  end
  
  def edit

	@title = "Edit host"
  end
  
  def create
	@host = Host.new(params[:host])
	if @host.save
		sign_in @host
		flash[:success] = "Welcome to Party Planners inc!"
		redirect_to @host
	else
		@title = "Sign up"
		render 'new'
	end
  end
  
  def update
	@host = Host.find(params[:id])
	if @host.update_attributes(params[:host])
	flash[:success] = "Profile updated."
	redirect_to @host
	else
	@title = "Edit host"
	render 'edit'
	end
  end
  
  def destroy
	Host.find(params[:id]).destroy
	flash[:success] = "Host destroyed."
	redirect_to hosts_path
end
  
 private
	def authenticate
		deny_access unless signed_in?
	end
	
	def correct_host
		@host = Host.find(params[:id])
		redirect_to(root_path) unless current_host?(@host)
	end
	
	def admin_user
		redirect_to(root_path) unless current_host.admin?
	end
end
