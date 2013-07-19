require 'thread'
require 'active_support/all'

module Whenever
  autoload :JobList,           'whenever/job_list'
  autoload :Job,               'whenever/job'
  autoload :CommandLine,       'whenever/command_line'

  module Output
    autoload :Cron,        'whenever/output/cron'
    autoload :Fcron,       'whenever/output/fcron'    
    autoload :Redirection, 'whenever/output/redirection'
  end

  def self.cron(options)
    Whenever::JobList.new(options).generate_cron_output
  end

  def self.path
    Dir.pwd
  end

  def self.rails3?
    File.exists?(File.join(path, 'script', 'rails'))
  end

  def self.bundler?
    File.exists?(File.join(path, 'Gemfile'))
  end
end
