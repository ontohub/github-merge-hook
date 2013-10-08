class GithubMergeHook::Deployment < Struct.new(:branch, :after_change_to)

  include GithubMergeHook::Git


  def perform
    fork do
      p self

      checkout branch

      set_paths

      cmd  = "KEY=\"#{@@keypath}\" "
      cmd += "GIT_SSH=\"#{@@ssh_wrapper}\" "
      cmd += "bundle exec cap deploy"

      run cmd
    end
  end


  private

  def run(cmd)
    p cmd
    system cmd or raise CommandFailed
  end

end
