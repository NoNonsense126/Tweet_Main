class PostTweet < ActiveRecord::Base
	belongs_to :twitter_user
  # Remember to create a migration!
end
