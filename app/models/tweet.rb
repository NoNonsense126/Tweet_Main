class Tweet < ActiveRecord::Base
	has_many :tweets
  belongs_to :twitter_user

  

  

end