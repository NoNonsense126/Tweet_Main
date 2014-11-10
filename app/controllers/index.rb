helpers do
  def user_logged
    user = nil
    if session[:user]
      user = TwitterUser.find_by(screen_name: session[:user])
    end
    user
  end

  def current_user
  	TwitterUser.find_by(screen_name: session[:user])
  end
end

get '/' do
  # Look in app/views/index.erb
  erb :index
end

get '/public' do
  "This is the public page - everybody is welcome!"
end

get '/private' do
  halt(401,'Not Authorized') unless admin?
  "This is the private page - members only"
end

get '/signin' do
  redirect to("/auth/twitter")
end
 
get '/logout' do
  session[:user] = nil
  "You are now logged out"
end

get '/auth/twitter/callback' do
		auth_token = env['omniauth.auth']["credentials"]["token"]
		auth_verifier = env['omniauth.auth']["credentials"]["secret"]
		screen_name = env['omniauth.auth']["extra"]["access_token"].params["screen_name"]
		@user = TwitterUser.find_by(screen_name: screen_name)
		unless @user
			@user = TwitterUser.create(screen_name: screen_name, oauth_token: auth_token,
											oauth_token_secret: auth_verifier)
			@user.fetch_tweets!
		end
		session[:user] = @user.screen_name
    session[:info] = {
      :avatar => env['omniauth.auth']['info']['image'],
      :name   => env['omniauth.auth']['info']['name'],
      :bio    => env['omniauth.auth']['info']['description']
    }
    @tweets = current_user.get_tweets
    
    erb :awesome
end

get '/awesome_features' do
  if user_logged.nil?
    erb :forbidden
  else
  	@username = session[:user]
  	@tweets = current_user.get_tweets
    erb :awesome
  end
end

get '/auth/failure' do
  params[:message]
  erb :auth_failure
end

post '/tweets' do
    # Getting logged user info in database
	@user = TwitterUser.find_by(screen_name: session[:user])
	@user.post_tweet(params[:body])
  erb :test
end