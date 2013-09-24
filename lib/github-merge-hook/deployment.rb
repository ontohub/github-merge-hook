class GithubMergeHook::Deployment < Struct.new(:branch, :after_change_to, :host)

  def perform
    fork do
      p self
      puts 'Here, a cap deploy will happen.'
    end
  end

end
