module RedditApi
  class Link < Thing
    attr_accessor :ups, :downs, :score, :saved, :clicked, :hidden, :over_18, :likes
    attr_accessor :domain, :title, :url, :author, :thumbnail
    attr_accessor :media, :media_embed
    attr_accessor :selftext, :selftext_html
    attr_accessor :num_comments
    attr_accessor :subreddit, :subreddit_id
    attr_accessor :is_self, :permalink

    register_as_reddit_type :t3

    def initialize(*args)
      opts = args.extract_options
      super
    end
    
  end
end
