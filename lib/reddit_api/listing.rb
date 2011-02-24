module RedditApi
  class Listing < Base
    include Enumerable
    attr_reader :children

    register_as_reddit_type 'Listing'

    def initialize(*args)
      @children = []
      super
    end

    def children=(cs)
      unless cs.is_a? Array
        raise RedditApiError.new('Attempted to create Listing with non-array for childern.')
      end
      cs.each do |c|
        @children << new_thing_from_params(c)
      end
    end

    def each(&blk)
      @children.each(&blk)
    end
    
    def [](i)
      @children[i]
    end
    
  end
end
