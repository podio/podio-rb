require 'test/unit'

require 'podio'

class Test::Unit::TestCase

  def setup
    set_podio_client
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
      :enable_stubs => true,
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

  def fixtures
    @fixtures ||= YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'fixtures.yaml'))
  end
end
