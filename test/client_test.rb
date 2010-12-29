require_relative 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    Podio.configure do |config|
      config.api_url = 'https://api.podio.com'
      config.api_key = 'client_id'
      config.api_secret = 'client_secret'
    end
  end

  test 'should configure defaults' do
    podio = Podio::Client.new

    assert_equal 'https://api.podio.com', podio.api_url
    assert_equal 'client_id', podio.api_key
    assert_equal 'client_secret', podio.api_secret
  end

  test 'should overwrite defaults' do
    podio = Podio::Client.new(:api_url => 'https://new.podio.com', :api_key => 'new_client_id', :api_secret => 'new_client_secret')

    assert_equal 'https://new.podio.com', podio.api_url
    assert_equal 'new_client_id', podio.api_key
    assert_equal 'new_client_secret', podio.api_secret
  end

  test 'should setup connection' do
    token = Podio::OAuthToken.new('access_token' => 'access', 'refresh_token' => 'refresh')
    podio = Podio::Client.new(:oauth_token => token)

    assert_equal token, podio.oauth_token

    assert_equal 'OAuth2 access', podio.connection.headers['authorization']
  end

  test 'should get an access token' do
    client = Podio::Client.new(:api_url => 'http://127.0.0.1:8080', :api_key => 'dev@hoisthq.com', :api_secret => 'CmACRWF1WBOTDfOa20A')
    assert_nil client.oauth_token

    client.get_access_token('pollas@hoisthq.com', 'secret')

    assert_not_nil client.oauth_token.access_token
    assert_not_nil client.oauth_token.refresh_token
  end

  test 'should be able to refresh access token' do
    client = podio_test_client
    old_token = client.oauth_token.dup

    client.refresh_access_token

    assert_not_equal old_token.access_token, client.oauth_token.access_token
    assert_equal old_token.refresh_token, client.oauth_token.refresh_token
  end

  test 'should be able to make arbitrary requests' do
    client = podio_test_client

    response = client.connection.get('/org/')
    assert_equal 200, response.status
    assert response.body.is_a?(Array)
  end
end
