module GithubMergeHook
  VERSION = '0.0.1'
end

# StdLib dependencies
require 'digest/sha1'
require 'json'
require 'yaml'
require 'singleton'

# The library path
lib = File.join(File.dirname(__FILE__), 'github-merge-hook')

# First require basic classes and modules.
%w(config git).each do |file|
  require File.join(lib, file)
end

# Load the settings.yml config file.
CONFIG = GithubMergeHook::Config.instance.load! 'settings.yml'

# Require any other ruby file in library path
Dir[File.join(lib, '*.rb')].sort.each { |file| require file }
