module RedditApi
  class User < Thing
    attr_writer :has_mail, :has_mod_mail, :is_mod
    attr_accessor :link_karma, :comment_karma
    
    register_as_reddit_type :t2
    
    def has_mail? 
      @has_mail == true
    end
    
    def has_mod_mail? 
      @has_mod_mail == true
    end
    
    def is_mod?
      @is_mod == true
    end
    
    
    def initialize(json={})
      super
    end

  end
end
