module RedditApi
  class User < Base
    attr_reader :kind, :id
    attr_reader :name, :created, :created_utc
    attr_reader :has_mail, :has_mod_mail, :is_mod
    attr_reader :link_karma, :comment_karma
    
    def initialize(json={})
      super
      @kind = json['kind']
      @id   = json['data']['id']
      @name = json['data']['name']
      @created = Time.at(json['data']['created'])
      @created_utc = Time.at(json['data']['created_utc'])
      @has_mail = json['data']['has_mail']
      @has_mod_mail = json['data']['has_mod_mail']
      @is_mod = json['data']['is_mod']
      @link_karma = json['data']['link_karma']
      @comment_karma = json['data']['comment_karma']
    end
    
    def web_id
      "#{@kind}_#{@id}"
    end
  end
end
