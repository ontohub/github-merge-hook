module GithubMergeHook::Git

  class CommandFailed < Exception
  end


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

    system cmd or raise CommandFailed
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
