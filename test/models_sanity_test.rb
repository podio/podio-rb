require 'test_helper'

class ModelsSanityTest < Test::Unit::TestCase

  ActiveSupport::Inflector.inflections do |inflect|
    inflect.uncountable %w( status user_status via )
  end

  models_directory = File.join(File.dirname(__FILE__), '..', 'lib', 'podio', 'models')
  model_files = Dir[File.join(models_directory, '**', '*')]
  model_files.each do |model_file|
    filename = File.basename(model_file, File.extname(model_file))
    model_class = ActiveSupport::Inflector.constantize("Podio::" + filename.classify) rescue nil
    
    if model_class
      test "should instansiate #{model_class.name}" do
        assert_nothing_raised { model_class.new }
      end
    end
  end
end