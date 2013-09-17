class GithubMergeHook::Merge < Struct.new(:from, :to)

  def perform
    fork do
      p self

      Dir.chdir CONFIG['workdir']

      dir  = CONFIG['repo_url'].split('/').last.split('.git').first
      dir += '-' + Digest::SHA1.hexdigest(from + to)
      
      unless Dir.exists? dir
        clone CONFIG['repo_url'], dir
      end

      Dir.chdir dir

      checkout to
#     reset :hard, 'origin/' + to
      merge 'origin/' + from, "Auto-merge of #{from} into #{to}."

      if CONFIG['push_dummy']
        git_command "remote add dummy #{CONFIG['push_dummy']}"
        push :dummy, to
      end
    end
  end

  private

  def checkout(branch)
    git_command :checkout, branch
  end

  def clone(url, target)
    git_command :clone, url, target
  end

  def git_command(command, *args)
    @@keypath     ||= File.expand_path(CONFIG['ssh_key'])
    @@ssh_wrapper ||= File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'scripts', 'git_ssh.sh'))

    cmd  = "KEY=\"#{@@keypath}\" "
    cmd += "GIT_SSH=\"#{@@ssh_wrapper}\" "
    cmd += "git #{command.to_s} #{args.join(' ')}"

    p cmd

    system cmd
  end

  def merge(branch, message)
    message = "-m '#{message}'"
    git_command :merge, branch, message
  end

  def push(remote, branch)
    git_command :push, remote, branch
  end

  def reset(option, head = nil)
    option = "--#{option.to_s}"
    git_command :reset, option, head
  end

end
