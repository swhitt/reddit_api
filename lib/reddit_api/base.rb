module RedditApi
  # All API objects that need a connection to the Reddit API will inherit from this base class.
  # The key component of each instance is the associated proxy (RedditApi::Proxy). It is through this
  # proxy that all Reddit requests are made. Whenever you create another Base-derived object that 
  # itself inherits from Base, be sure to pass the proxy. That way authentication is preserved throughout
  # the chain. 
  class Base
    include ActiveModel::Validations
    # This will map from a reddit `kind` to a ruby class name (as a string in the RedditApi module).
    # Any of the destination types should inherit from the RedditApi::Thing base class. 
    # The mapping is added to via the `register_as_reddit_type` class method.
    KIND_MAP = {}
    
    # Store and make accessible the proxy we are using to access reddit. All that we require is that it
    # implements the #do_action method
    attr_accessor :proxy
    
    # The constructor for RedditApi::Base will take a hash and attempt to set the values described by it.
    def initialize(*args)
      attr_hash = args.extract_options
      @proxy = attr_hash.delete(:proxy) || Proxy.new(attr_hash)
      attr_hash.each_pair do |key, value|
        m = "#{key}=".to_sym
        next unless self.respond_to? m
        send(m, value)
      end
    end
    
    protected
    
    # Run this method before any local reqs to make sure the proxy is set and is able to do actions (duck typing, anyone?)
    # TODO: Don't throw Exception, make our own type.
    def check_for_proxy
      unless @proxy && @proxy.respond_to?(:do_action)
        raise RedditApiError.new('Proxy is not set correctly!')
      end
    end
    
    # Check for login, throw an exception if we're not logged in.
    # TODO: Don't throw Exception, make our own type.
    def require_login
      check_for_proxy
      unless @proxy.logged_in?
        raise RedditApiError.new('You must be logged in to do that.')
      end
    end
    
    # Run some checks before passing the arguments along to the proxy.
    # Double check to make sure a proxy in-spec is specified, process the result.
    # If the Reddit `kind` field is set, see if we have a mapping to a local ruby type (in KIND_MAP) and pass it along.
    # Otherwise, pass along the HTTParty::Response.
    # Return false if a failure occurs.
    def do_action(*args)
      check_for_proxy
      result = proxy.do_action(*args)
      if result.is_a? Hash 
        # If the result's a hash, the service returned valid JSON which was interpreted.
        # Map the result to an object in our domain, using the mappings in KIND_MAP
        if result['kind']
          new_thing_from_params(result) || result
        else 
          # if we can't map it, return the HTTParty::Response
          result
        end
      else
        # Otherwise, one of two things occurred - we requested an object that was raw (like a stylesheet or an HTML page)
        # or an error occurred and we got the 'You broke Reddit' page!
        # check to see if we were expecting a raw result or not.
        extra_opts = args.extract_options
        if extra_opts[:raw]
          result
        else
          false
        end
      end
    end
    
    def new_thing_from_params(params_hash)
      klass = get_class_from_type(params_hash['kind'])
      klass ? klass.new(params_hash['data'].merge({:proxy => @proxy})) : nil
    end
    
    # Check the 'type' attribute of the returned JSON. If we have a mapping to an object, return the class associated with it
    def get_class_from_type(type_id)
      KIND_MAP[type_id.to_sym] || false
    end
    
    class << self
      def register_as_reddit_type(type_id)
        klass = self
        KIND_MAP[type_id.to_sym] = klass
        klass.send(:define_method, :kind) do
          type_id
        end
      end
    end
        
  end
end
