module RedditApi
  class User
    attr_reader :kind, :id
    attr_reader :name, :created, :created_utc
    attr_reader :has_mail, :has_mod_mail, :is_mod
    attr_reader :link_karma, :comment_karma
    
    def initialize(json={})
      @kind = json['kind']
      @id   = json['data']['id']
    end
    
    def web_id
      "#{@kind}_#{@id}"
    end
  end
end
