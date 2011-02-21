module RedditApi
  class RedditApiError < StandardError
  end  
end

unless [].respond_to?(:extract_options)
  class Array
    def extract_options
      last.is_a?(Hash) ? last : {}
    end
  end
end
