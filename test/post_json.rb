require 'httparty'
require 'json'

class TestGithubMergeHook

  include HTTParty

  base_uri 'localhost:3000'

  def self.post_json(json)
    post '/', query: {payload: json}
  end

end

path = ARGV[0]
path = File.join(File.dirname(__FILE__), path) unless File.exists? path

TestGithubMergeHook.post_json File.open(path).read
