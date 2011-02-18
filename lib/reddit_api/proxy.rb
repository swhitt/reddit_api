module RedditApi
  class Proxy
    include HTTParty
    
    attr_accessor :cookie, :username    
    
    base_uri 'https://www.reddit.com'
    
    def initialize(params={})
      unless (params[:username].blank? || params[:password].blank?)
        login(params[:username], params[:password])
      end
    end
    
    def do_action(path, verb = :get, parameters = {} )
      verb = verb.to_sym
      response = self.class.send(verb, path, {
        ((verb == :get) ? :query : :body) => parameters,
        :headers => headers_for_request
      })
      (response.code == 200) ? response : false
    end
    
    def login(u, p)
      response = do_action('/api/login', :post, {:user => u, :passwd => p})
      headers = response.headers if response
      
      if headers['set-cookie'] && headers['set-cookie'].match('reddit_session')
        @cookie   = headers['set-cookie']
        @username = u
        true
      else
        false
      end
    end
    
    def logged_in?
      !(cookie.blank? || username.blank?)
    end
    
    def inspect
      logged_in_as = (logged_in? ? "Logged in as #{username}" : 'Not logged in' )
      "<RedditApi::Proxy - #{logged_in_as}>"
    end
    
    private
    
    def headers_for_request
      hash = { 'user-agent' => "RedditApi #{RedditApi::VERSION}" }
      hash['Cookie'] = @cookie if logged_in?
      hash
    end
    
  end
end
