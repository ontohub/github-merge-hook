require 'rubygems'

require 'bundler'

Bundler.require

require File.join(File.dirname(__FILE__), 'lib', 'github-merge-hook.rb')
run GithubMergeHook::Server
