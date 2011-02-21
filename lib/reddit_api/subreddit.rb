module RedditApi
  class Subreddit < Thing
    
    DISPLAY_NAME_REGEX = /^[A-Za-z0-9][A-Za-z0-9_]{2,20}$/
    URL_REGEX = /^\/r\/[A-Za-z0-9][A-Za-z0-9_]{2,20}\/$/
    
    attr_accessor :display_name, :title
    attr_writer :url
    attr_accessor :subscribers
    attr_accessor :description
    attr_accessor :over18

    register_as_reddit_type :t5

    validates_format_of :url, :with => URL_REGEX
    validates_format_of :display_name, :with => DISPLAY_NAME_REGEX, 
      :if => Proc.new {|sr| (! URL_REGEX.match(sr.url))}
    
    def initialize(*args)
      opts = args.extract_options
      if args[0].is_a? String
        @display_name = args[0]
      end
      super
    end
    
    def url
      return false if (display_name.blank? && @url.blank?)
      @url.blank? ? "/r/#{display_name}/" : @url
    end
    
    def get_links(limit=nil)
      require_valid_url
      req_params = {:raw => true}
      req_params[:query] = {:limit => limit.to_i} if limit.to_i > 0
      do_action("#{url}.json", :get, req_params)
    end
    
    alias_method :get_posts, :get_links
    
    def get_stylesheet
      require_valid_url
      do_action("#{url}stylesheet.css", :get, :raw => true)
    end
    
    def change_stylesheet(new_stylesheet)
      require_valid_url
      require_login
      do_action('/api/subreddit_stylesheet', :post, :body => {
        :op => 'save', 
        :r => display_name, 
        :stylesheet_contents => new_stylesheet
      })
    end
    
    def self.get_stylesheet_for(subreddit_name)
      inst = new(subreddit_name).get_stylesheet
    end
    
    private

    def require_valid_url
      unless (valid? || errors[:url].empty?)
        raise RedditApiError.new "The Subreddit URL specified ('#{url}') is invalid."
      end
    end
    
  end
end
