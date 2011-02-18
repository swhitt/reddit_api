#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require "ruby-debug"

require 'pry'
require 'ap'

require File.join(File.dirname(__FILE__), 'lib', 'reddit_api')

proxy = RedditApi::Proxy.new
Pry.start

