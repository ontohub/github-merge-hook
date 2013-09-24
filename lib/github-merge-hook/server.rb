class GithubMergeHook::Server < Sinatra::Base

  include GithubMergeHook

  def authorized?(ip)
    return true if CONFIG['networks'].nil?

    ip = IPAddress.parse(ip)
    a  = false

    CONFIG['networks'].each do |network|
      a ||= IPAddress.parse(network).include? ip
    end

    a
  end

  if CONFIG['log_requests']
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

    halt unless CONFIG['merge'].include? branch

    to = CONFIG['merge'][branch]

    deployment = begin
      host = CONFIG['deploy'][to]['host']
      Deployment.new(to, branch, host)
    rescue NoMethodError
      nil
    end

    Merge.new(branch, to, deployment).perform
  end

end
