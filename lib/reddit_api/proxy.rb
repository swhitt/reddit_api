module RedditApi
  class Proxy
    include HTTParty
    debug_output $stdout
    attr_accessor :cookie, :username, :modhash    
    
    base_uri 'https://www.reddit.com'
    
    # Create a new RedditApi::Proxy. If passed a hash with {:login => {:username => 'joeschmoe', :password => 'hunter2'}},
    # attempt to log in and store session.
    def initialize(params={})
      login_hash = params[:login] || {}
      unless (login_hash[:username].blank? || login_hash[:password].blank?)
        login(login_hash[:username], login_hash[:password])
      end
    end
    
    # The core of the Proxy class. Perform an action against the Reddit API.
    # TODO: Should throw an exception if we don't recieve a valid 2xx response.
    def do_action(path, verb = :get, parameters = {})
      verb = verb.to_sym
      response = self.class.send(verb, path, {:headers => headers_for_request }.merge( action_params(verb, parameters) ))
      (response.code == 200) ? response : false
    end
    
    # Login to Reddit for performing log-in-only actions.
    # Returns true if the login was a success (a session cookie was returned) and sets @cookie, @modhash
    # and @username for the user that logged in. Returns false if we did not succeed. 
    def login(u, p)
      response = do_action("/api/login/#{u}", :post, {:body => {:user => u, :passwd => p, :api_type => :json}})
      headers = response.headers if response
      if headers['set-cookie'] && headers['set-cookie'].match('reddit_session')
        @cookie   = headers['set-cookie']
        @username = u
        @modhash  = response['json']['data']['modhash']
        true
      else
        false
      end
    end
    
    # Returns the User object that represents the logged-in-user for this proxy.
    # If we don't already have the information about the user, perform an API request to retrieve it.
    def user
      return false unless logged_in?
      @user ||= RedditApi::Reddit.new(:proxy => self).get_reddit_user(@username)
    end
    
    # Return whether this Proxy is logged into the Reddit API.
    # If we're logged in, we'll have the session cookie, the username of the current logged in user
    # and the modhash for that user. 
    def logged_in?
      !(cookie.blank? || username.blank? || modhash.blank?)
    end
    
    def inspect
      logged_in_as = (logged_in? ? "Logged in as #{username}" : 'Not logged in' )
      "<RedditApi::Proxy - #{logged_in_as}>"
    end
    
    private
    
    # If we're logged in we need to send the session cookie for authentication purposes. 
    # Additionally, use of the Reddit API requires a valid user-agent. Set the User Agent based
    # off of the current version. 
    def headers_for_request
      hash = { 'user-agent' => "reddit_api #{RedditApi::VERSION} for ruby" }
      hash['Cookie'] = @cookie if logged_in?
      hash
    end
    
    # Returns the hash that represents the parameters for the given action
    # For GETs, we need to use the :query hash key to set parameters. If we are sending a POST, we need to
    # use the :body hash key to set parameters.
    # Additionally, if we are doing a POST when we are logged in (modifying data), we need to set the
    # reddit UH parameter with the logged-in-user's modhash. 
    def action_params(verb, params)
      action_param_key = ((verb == :get) ? :query : :body)
      action_params = (params[action_param_key] || {})
      action_params[:uh] ||= modhash if (logged_in? && verb == :post)
      {action_param_key => action_params}
    end
    
  end
end
