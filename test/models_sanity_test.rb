require 'test_helper'
require 'ruby-debug'

class ModelsSanityTest < Test::Unit::TestCase
  models_directory = File.join(File.dirname(__FILE__), '..', 'lib', 'podio', 'models')
  model_files = Dir[File.join(models_directory, '**', '*')]
  model_files.each do |model_file|
    filename = File.basename(model_file, File.extname(model_file))
    model_class = ActiveSupport::Inflector.constantize("Podio::" + filename.classify)
    
    test "should instansiate #{model_class.name}" do
      assert_nothing_raised { model_class.new }
    end
  end
end