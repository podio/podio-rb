require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
