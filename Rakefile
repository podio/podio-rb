require 'rake'
require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  ENV['ENABLE_STUBS'] = 'true'
  ENV['ENABLE_RECORD'] = 'false'
  t.ruby_opts = ["-rubygems"] if defined? Gem
  t.libs << "lib" << "test"
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Record responses'
task :record do
  ENV['ENABLE_RECORD'] = 'true'
  ENV['ENABLE_STUBS'] = 'false'

  Dir['test/**/*_test.rb'].each do |f|
    ruby("-Ilib:test", f)

    folder_name = f.match(/test\/(.+)_test.rb/)[1]
    FileUtils.mkdir_p("test/fixtures/#{folder_name}")
    FileUtils.mv(Dir.glob('*.rack'), "test/fixtures/#{folder_name}")
  end
end
