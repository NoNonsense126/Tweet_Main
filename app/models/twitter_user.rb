class TwitterUser < ActiveRecord::Base
	has_many :tweets
	has_many :post_tweets

	def post_tweet(time, body)
		tweet = PostTweet.create!(twitter_user_id: self.id, body: body)
		TweetWorker.perform_async(tweet.id)
	end

	def post_tweet_later(time, body)
		tweet = PostTweet.create!(twitter_user_id: self.id, body: body)
		TweetWorker.perform_at(time.to_i.minutes, tweet.id)		
	end

    """Connect to the Twitter API and pull down the latest tweets"""
  def fetch_tweets!
  	client = generate_client
    tweets = client.user_timeline(screen_name, {count: 10})
		tweets.each do |tweet|
			Tweet.create(twitter_user_id: id, body: tweet.text )
		end
  end

  def get_tweets
  	Tweet.where(twitter_user_id: id)
  end


  def tweets_stale?
  	tweet = Tweet.find_by(twitter_user_id: id)
  	if tweet
  		return (Time.now - tweet.updated_at) > 900
  	else
  		false
  	end
  end

  private

  def generate_client
	  client = Twitter::REST::Client.new do |config|
	    config.consumer_key = APP_KEY["consumer_key"]
	    config.consumer_secret = APP_KEY["consumer_secret"]
	    config.access_token = oauth_token
	    config.access_token_secret = oauth_token_secret
  	end
  	client
  end
end
