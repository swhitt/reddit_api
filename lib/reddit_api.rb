require 'httparty'
require 'active_model'

module RedditApi
end

REDDIT_API_PATH =  File.expand_path(File.dirname(__FILE__) + '/reddit_api') + '/'
[
  'util',
  'proxy',
  'base',
  
  'thing',
  'user',
  'subreddit',
  'reddit',
  'link',
  'listing'
].each do |library|
  require REDDIT_API_PATH + library
end
