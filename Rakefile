require 'rake/testtask'
require 'bundler'

Bundler::GemHelper.install_tasks

desc 'Run tests'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Record responses'
task :record do
  ENV['ENABLE_RECORD'] = 'true'

  Dir['test/**/*_test.rb'].each do |f|
    ruby('-Ilib', f)

    folder_name = f.match(/test\/(.+)_test.rb/)[1]
    FileUtils.mkdir_p("test/fixtures/#{folder_name}")
    FileUtils.mv(Dir.glob('*.rack'), "test/fixtures/#{folder_name}")
  end
end
