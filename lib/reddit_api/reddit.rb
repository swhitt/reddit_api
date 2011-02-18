module RedditApi
  class Reddit < Base
    
    def get_reddit_user(username)
      result = proxy.do_action("/user/#{username}/about.json")
    end
      
  end
end
