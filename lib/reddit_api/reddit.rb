module RedditApi
  # RedditApi::Reddit is the class used to encapsulate the global functionality for the site. 
  # Will be used for things like looking up subreddits, getting front page info, etc.
  class Reddit < Base
    
    # Request a user's information. Should return a RedditApi::User with the results filled in.
    def get_user(username)
      do_action("/user/#{username}/about.json")
    end
    
    # Request a subreddit's information. Should return a Reddit::Subreddit populated with the response data. 
    def get_subreddit(subreddit)
      do_action("/r/#{subreddit}/about.json")
    end
  end
end
