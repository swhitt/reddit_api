# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reddit_api/version"

Gem::Specification.new do |s|
  s.name        = "reddit_api"
  s.version     = RedditApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Steve Whittaker"]
  s.email       = ["swhitt@gmaill.com"]
  s.homepage    = "http://reddithouston.com"
  s.summary     = %q{A quirky reddit.com API for use by /r/houston}
  s.description = %q{This will interact delightfully with the reddit api, using only the limited features required by the /r/houston management application! Maybe more later.}

  s.rubyforge_project = "reddit_api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'httparty'
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec', '~> 2.4.0'
end
