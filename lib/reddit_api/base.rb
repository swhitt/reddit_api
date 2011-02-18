module RedditApi
  class Base
    attr_accessor :proxy
    
    def initialize(params={})
      @proxy = params[:proxy] || Proxy.new(params)
    end
    
    protected
    
    def check_for_proxy
      unless @proxy && @proxy.respond_to?(:do_action)
        raise Exception.new('Proxy is not set correctly')
      end
    end
    
    def do_action(*args)
      check_for_proxy
      result = proxy.do_action(*args)
      return false unless result.is_a? Hash
      opts = args.extract_options
      opts[:result_class] ? opts[:result_class].new(result.merge({:proxy => @proxy})) :  result
    end
        
  end
end
