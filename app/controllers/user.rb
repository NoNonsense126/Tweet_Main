post '/tweets' do
    # Getting logged user info in database
	@user = TwitterUser.find_by(screen_name: session[:user])
	@user.post_tweet(params[:body])
  erb :test
end

post '/:username/stale' do
	@user = TwitterUser.find_by(username: params[:username])
	if @user.tweets_stale?
		@tweets = @user.fetch_tweets!(params[:username])
		@tweets.each do |tweet|
			Tweet.create(twitter_user_id: @user.id, body: tweet.text )
		end
		@tweets = Tweet.where(twitter_user_id: @user.id)
		erb :'_partials/_tweet_container'
	else
		403
	end
end