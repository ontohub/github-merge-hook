module GithubMergeHook
  VERSION = '0.0.1'
end

require 'ipaddress'
require 'json'
require 'sinatra/base'
require 'singleton'

path = File.join(File.dirname(__FILE__), 'github-merge-hook')
Dir[path + '/*.rb'].each { |file| require file }
