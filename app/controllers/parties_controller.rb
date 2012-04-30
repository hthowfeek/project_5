class PartiesController < ApplicationController
	before_filter :authenticate
	
	def create
		@party = current_host.parties.build(params[:micropost])
		if @party.save
			flash[:success] = "Party created!"
			redirect_to root_path
		else
			render 'pages/home'
		end
	end		
	
	def destroy
	end
end