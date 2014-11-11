class CreatePostTweets < ActiveRecord::Migration
  def change
  	create_table :post_tweets do |t|
  		t.string :body
  		t.integer :twitter_user_id

  		t.timestamps
  	end
  end
end
