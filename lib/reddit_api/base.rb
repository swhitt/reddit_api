module RedditApi
  class Base
    # This will map from a reddit `kind` to a ruby class name (as a string in the RedditApi module)
    KIND_MAP = {
      't2' => 'User',
      't5' => 'Subreddit'
    }
    
    # Store and make accessible the proxy we are using to access reddit. All that we require is that it
    # implements the #do_action method
    attr_accessor :proxy
    
    def initialize(params={})
      @proxy = params[:proxy] || Proxy.new(params)
    end
    
    protected
    
    # Run this method before any local reqs to make sure the proxy is set and is able to do actions (duck typing, anyone?)
    def check_for_proxy
      unless @proxy && @proxy.respond_to?(:do_action)
        raise Exception.new('Proxy is not set correctly')
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
          klass = get_class_from_type(result['kind'])
          klass ? klass.new(result['data'].merge({:proxy => @proxy})) : result
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
    
    def get_class_from_type(type)
      type_string = KIND_MAP[type.to_s]
      return false unless type_string
      RedditApi.const_defined?(type_string) ? RedditApi.const_get(type_string) : RedditApi.const_missing(type_string)
    end
        
  end
end
