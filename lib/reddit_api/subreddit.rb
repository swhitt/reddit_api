module RedditApi
  class Subreddit < Thing
    attr_accessor :display_name, :title, :url
    attr_accessor :subscribers
    attr_accessor :description
    attr_accessor :over18

    register_as_reddit_type :t5

    def initialize(*args)
      opts = args.extract_options
      if args[0].is_a? String
        @display_name = args[0]
      end
      super
    end
    
    def base_url
      return false if (display_name.blank? && url.blank?)
      url.blank? ? "/r/#{display_name}/" : url
    end
    
    def get_stylesheet
      return false if ! base_url
      do_action("#{base_url}stylesheet.css", :get, :raw => true)
    end
    
    def change_stylesheet(new_stylesheet)
      return false if base_url.blank?
      require_login
      do_action('/api/subreddit_stylesheet', :post, :body => {
        :op => 'save', 
        :r => display_name, 
        :stylesheet_contents => new_stylesheet
      })
    end
  end
end
