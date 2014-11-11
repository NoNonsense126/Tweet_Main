# app/models/tweet_worker.rb
class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = PostTweet.find(tweet_id)
    user = tweet.twitter_user
    sleep(5)
	  client = Twitter::REST::Client.new do |config|
	    config.consumer_key = APP_KEY["consumer_key"]
	    config.consumer_secret = APP_KEY["consumer_secret"]
	    config.access_token = user.oauth_token
	    config.access_token_secret = user.oauth_token_secret
  	end
  	client.update(tweet.body)
  end
end