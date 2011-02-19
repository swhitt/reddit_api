module RedditApi
  class Thing < Base
    attr_accessor :id, :name
    attr_reader :created, :created_utc

    def web_id
      "#{kind}_#{@id}"
    end
    
    def created=(dt)
      @created = Time.at(dt)
    rescue
      @created = dt
    end
    
    def created_utc=(dt)
      @created_utc = Time.at(dt).utc
    rescue
      @created_utc = dt
    end
    
  end
end
