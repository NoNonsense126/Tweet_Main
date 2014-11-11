post '/tweets' do
    # Getting logged user info in database
	@user = TwitterUser.find_by(screen_name: session[:user])
	@job_id = @user.post_tweet(params[:body])
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

post '/tweets_later' do
    # Getting logged user info in database
	@user = TwitterUser.find_by(screen_name: session[:user])
	@job_id = @user.post_tweet_later(params[:time], params[:body])
end