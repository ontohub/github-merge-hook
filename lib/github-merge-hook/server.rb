class GithubMergeHook::Server < Sinatra::Base

  include GithubMergeHook

  def authorized?(ip)
    ip = IPAddress.parse(ip)
    a  = false

    @@config['networks'].each do |network|
      a ||= IPAddress.parse(network).include? ip
    end

    a
  end

  @@config = Config.instance.load! 'settings.yml'

  if @@config['log']
    configure :production, :development do
      enable :logging
    end
  end

  post '/' do
    halt unless authorized? request.env['REMOTE_ADDR']

    json = JSON.parse(params[:payload])

    begin
      branch = json['ref'].split('/').last
    rescue NoMethodError
      halt
    end

    halt unless @@config['merge'].include? branch

    to = @@config['merge'][branch]

    Merge.new(branch, to).perform
  end

end
