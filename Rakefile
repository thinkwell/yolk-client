require 'bundler'
Bundler::GemHelper.install_tasks

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r yolk-client.rb"
end