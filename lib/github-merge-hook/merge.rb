class GithubMergeHook::Merge < Struct.new(:from, :to, :deployment)

  include GithubMergeHook::Git


  def perform
    fork do
      p self

      Dir.chdir CONFIG['workdir']

      unless Dir.exists? dir
        clone CONFIG['repo_url'], dir
      end

      Dir.chdir dir

      checkout to
#     reset :hard, 'origin/' + to
      merge 'origin/' + from, "Auto-merge of #{from} into #{to}."

      begin
        if CONFIG['push_dummy']
          push_dummy
        else
          push :origin, to
        end
      rescue CommandFailed
        puts 'Deployment cancelled, push did not work.'
        exit
      end

      deployment.perform if deployment
    end
  end


  private

  def dir
    @dir ||= begin
      dir  = CONFIG['repo_url'].split('/').last.split('.git').first
      dir += [nil, from, to].join('-')
    end
  end

  def push_dummy
    unless Dir.exists? CONFIG['push_dummy']
      Dir.mkdir CONFIG['push_dummy']
      git_command :init, CONFIG['push_dummy']
    end

    begin
      git_command :remote, :add, :dummy, CONFIG['push_dummy']
    rescue CommandFailed
    end

    push :dummy, to
  end

end
