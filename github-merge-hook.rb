require 'json'
require 'sinatra/base'
require 'singleton'

class GithubMergeHook < Sinatra::Base

  class Merge < Struct.new(:from, :to)
    def perform
      fork do
        p self
      end
    end
  end

  class Config < Hash
    include Singleton
    
    def load!(path)
      unless File.exists? path
        path = File.join(File.dirname(__FILE__), path)
      end

      self.merge! YAML.load_file(path)
    end
  end

# configure :production, :development do
#   enable :logging
# end

  @@config = Config.instance.load! 'settings.yml'

  post '/' do
    json = JSON.parse(params[:payload])

    begin
      branch = json['ref'].split('/').last
    rescue NoMethodError
      halt
    end

    halt unless @@config['merge'].include? branch

    to = @@config['merge'][branch]

    #ip = IPAddress request.env['REMOTE_ADDR']

    Merge.new(branch, to).perform
  end

  if app_file == $0
    run!
  end

end
