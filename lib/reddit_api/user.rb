module RedditApi
  class User < Base
    attr_reader :id
    attr_reader :name, :created, :created_utc
    attr_reader :has_mail, :has_mod_mail, :is_mod
    attr_reader :link_karma, :comment_karma
    
    def kind
      't2'
    end
    
    def initialize(json={})
      super
      @id   = json['id']
      @name = json['name']
      @created = Time.at(json['created'])
      @created_utc = Time.at(json['created_utc'])
      @has_mail = json['has_mail']
      @has_mod_mail = json['has_mod_mail']
      @is_mod = json['is_mod']
      @link_karma = json['link_karma']
      @comment_karma = json['comment_karma']
    end
    
    def web_id
      "#{kind}_#{@id}"
    end
  end
end
