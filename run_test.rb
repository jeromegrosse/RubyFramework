require 'find'
BASE_PATH = File.expand_path File.dirname(__FILE__)

Find.find(File.dirname(__FILE__) + "/test/") do |path|
  Find.prune if path =~ /#{File.expand_path('.')}\/#{__FILE__}$/
  require path.reverse.chomp(File.expand_path('.').reverse).chomp('/').reverse.chomp('.rb') if !File.directory?(path)
end