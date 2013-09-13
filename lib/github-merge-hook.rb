module GithubMergeHook
  VERSION = '0.0.1'
end

# Project dependencies
require 'digest/sha1'
require 'ipaddress'
require 'json'
require 'sinatra/base'
require 'singleton'

# The library path
lib = File.join(File.dirname(__FILE__), 'github-merge-hook')

# First require the Config class and load the settings.yml config file.
require File.join(lib, 'config.rb')
CONFIG = GithubMergeHook::Config.instance.load! 'settings.yml'

# Require any other ruby file in library path
Dir[File.join(lib, '*.rb')].each { |file| require file }
