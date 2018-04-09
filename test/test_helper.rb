require 'podio'

require 'yaml'
require 'active_support'
require 'minitest/autorun'

ActiveSupport::TestCase.test_order = :sorted

class ActiveSupport::TestCase
  def setup
    set_podio_client
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
