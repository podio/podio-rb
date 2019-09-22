require 'rake'
require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

task :default => [:test]

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.ruby_opts = ["-r rubygems"] if defined? Gem
  t.libs << "lib" << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
