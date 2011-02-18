module RedditApi
  class Base
    attr_accessor :proxy
    
    def initialize(params={})
      @proxy = params[:proxy] || Proxy.new(params)
    end
    
  end
end
