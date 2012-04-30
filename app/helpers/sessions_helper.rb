module SessionsHelper
	
	def sign_in(host)
		cookies.permanent.signed[:remember_token] = [host.id, host.salt ]
		self.current_host = host
	end
	
	def current_host=(host)
		@current_host = host
	end
	
	def current_host
		@current_host ||= host_from_remember_token
	end
	
	def signed_in?
		!current_host.nil?
	end
	
	def sign_out
		cookies.delete(:remember_token)
		self.current_host = nil
	end
	
	private
	
	def host_from_remember_token
		Host.authenticate_with_salt(*remember_token)
	end
	
	def remember_token
		cookies.signed[:remember_token] || [nil, nil]
	end
	
	def deny_access
		store_location
		redirect_to signin_path, :notice => "Please sign in to access this page."
	end
	
	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		clear_return_to
	end
	
	def current_host?(host)
		host == current_host
	end
	
	def store_location
	session[:return_to] = request.fullpath
	end
	
	def clear_return_to
	session[:return_to] = nil
	end
	
	def authenticate
		deny_access unless signed_in?
	end
end
