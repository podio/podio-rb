require 'test/unit'
require 'yajl'

require 'podio'

ENABLE_STUBS  = ENV['ENABLE_STUBS'] == 'true'
ENABLE_RECORD = ENV['ENABLE_RECORD'] == 'true'

class Test::Unit::TestCase

  def setup
    set_podio_client
    stub_responses if ENABLE_STUBS
  end

  # test "verify something" do
  #   ...
  # end
  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end

  def set_podio_client
    Podio.client = Podio::Client.new(
      :api_url      => 'http://api-sandbox.podio.dev',
      :api_key      => 'sandbox@podio.com',
      :api_secret   => 'sandbox_secret',
      :enable_stubs => ENABLE_STUBS && !ENABLE_RECORD,
      :record_mode  => ENABLE_RECORD,
      :test_mode    => true
    )
  end

  USED_TOKENS = {}
  def login_as(user_identifier)
    user = fixtures[:users][user_identifier]
    USED_TOKENS[user[:mail]] ||= Podio.client.authenticate_with_credentials(user[:mail], user[:password])
    Podio.client.oauth_token = USED_TOKENS[user[:mail]]
    Podio.client.reset
  end

  def stub_responses
    folder_name = self.class.name.underscore.gsub('_test', '')
    current_folder = File.join(File.dirname(__FILE__), 'fixtures', folder_name)

    if File.exists?(current_folder)
      Dir.foreach(current_folder) do |filename|
        next unless filename.include?('.rack')

        rack_response = eval(File.read(File.join(current_folder, filename)))

        url    = rack_response.shift
        method = rack_response.shift

        Podio.client.stubs.send(method, url) { rack_response }
      end
    end
  end
  
  def fixtures
    @fixtures ||= YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'fixtures.yaml'))
  end
end
