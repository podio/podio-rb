require_relative 'test_helper'

context 'ClientTest' do
  context 'client configuration' do
    setup do
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

      assert_equal({'oauth_token' => 'access'}, podio.connection.params)
    end
  end

  context 'oauth2 authorization' do
    test 'should get an access token' do
      client = Podio::Client.new(:api_url => 'https://api.podio.com', :api_key => 'client_id', :api_secret => 'client_secret')
      assert_nil client.oauth_token

      stub_post(
        '/oauth/token?grant_type=password&client_id=client_id&client_secret=client_secret&username=username&password=password',
        {'access_token' => 'access', 'refresh_token' => 'refresh', 'expires_in' => 3600}
      )

      client.get_access_token('username', 'password')

      assert_equal 'access', client.oauth_token.access_token
      assert_equal 'refresh', client.oauth_token.refresh_token
    end

    test 'should be able to refresh access token' do
      client = podio_test_client

      stub_post(
        '/oauth/token?grant_type=refresh_token&refresh_token=refresh&client_id=client_id&client_secret=client_secret',
        {'access_token' => 'new_access', 'refresh_token' => 'refresh', 'expires_in' => 3600}
      )

      client.refresh_access_token

      assert_equal 'new_access', client.oauth_token.access_token
      assert_equal 'refresh', client.oauth_token.refresh_token
    end
  end

  context 'raw connection' do
    test 'should be able to make arbitrary requests' do
      client = podio_test_client

      stub_get('/?oauth_token=access', { 'messaging' => true, 'version' => '1.0.1' })

      response = client.connection.get('/')
      assert_equal 200, response.status
      assert_equal({ 'messaging' => true, 'version' => '1.0.1' }, response.body)
    end
  end
end
