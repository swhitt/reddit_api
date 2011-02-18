module RedditApi
  class Subreddit < Base
    attr_accessor :id
    attr_accessor :display_name, :name, :title, :url
    attr_accessor :created, :created_utc, :subscribers
    attr_accessor :description
    attr_accessor :over18
  
    def initialize(params={})
      super
    end
    
    def kind
      't5'
    end
    
    def web_id
      name
    end
    
    def base_url
      return false if (display_name.blank? && url.blank?)
      url.blank? ? "/r/#{display_name}/" : url
    end
    
    def get_stylesheet
      return false if base_url.blank?
      do_action("#{base_url}stylesheet.css", :get, :raw => true)
    end
  end
end
