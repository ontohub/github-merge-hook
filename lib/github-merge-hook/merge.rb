class GithubMergeHook::Merge < Struct.new(:from, :to)

  def perform
    fork do
      p self
    end
  end

end
