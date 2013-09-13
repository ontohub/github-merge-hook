class GithubMergeHook::Config < Hash

  include Singleton
  
  def load!(path)
    unless File.exists? path
      path = File.join(File.dirname(__FILE__), path)
    end

    self.merge! YAML.load_file(path)
  end

end
