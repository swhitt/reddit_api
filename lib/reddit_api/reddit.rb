module RedditApi
  class Reddit < Base
    
    def get_reddit_user(username)
      result = do_action("/user/#{username}/about.json", :get, :result_class => User)
    end
      
  end
end
