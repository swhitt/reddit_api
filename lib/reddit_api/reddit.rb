module RedditApi
  class Reddit < Base
    
    def get_reddit_user(username)
      result = do_action("/user/#{username}/about.json")
    end
    
    def get_subreddit(subreddit)
      result = do_action("/r/#{subreddit}/about.json")
    end
  end
end
