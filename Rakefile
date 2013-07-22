begin
  require 'bundler'
rescue LoadError => e
  warn("warning: Could not load bundler: #{e}")
  warn("         Some rake tasks will not be defined")
else
  Bundler::GemHelper.install_tasks
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs      << 'lib' << 'test'
  test.pattern   = 'test/{functional,unit}/**/*_test.rb'
  test.verbose   = true
end

module Bundler
  class GemHelper
  protected
    def rubygem_push(path)
      Bundler.with_clean_env do
        out, status = sh("gem inabox #{path}")
        raise "You should configure your Geminabox url: gem inabox -c" if out[/Enter the root url/]
        Bundler.ui.confirm "Pushed #{name} #{version} to Geminabox"
      end
    end
  end
end

task :default => :test