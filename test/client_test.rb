require 'test_helper'

class ClientTest < Test::Unit::TestCase
  test 'should setup client' do
    Podio.setup(:api_key => 'client_id', :api_secret => 'client_secret')
  
    assert_equal Podio::Client, Podio.client.class
    assert_equal 'client_id', Podio.client.api_key
    assert_equal 'client_secret', Podio.client.api_secret
  end
  
  test 'should initialize client' do
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
    client = Podio.client
    client.oauth_token = nil
    assert_nil client.oauth_token
  
    user = fixtures[:users][:professor]
    client.authenticate_with_credentials(user[:mail], user[:password])
  
    assert_not_nil client.oauth_token.access_token
    assert_not_nil client.oauth_token.refresh_token
  end

  test 'should be able to refresh access token' do
    login_as(:fry)
    client = Podio.client
    old_token = client.oauth_token.dup

    client.refresh_access_token

    assert_not_equal old_token.access_token, client.oauth_token.access_token
    assert_equal old_token.refresh_token, client.oauth_token.refresh_token
  end

  test 'should automatically refresh an expired token' do
    # this token is already expired in the test database
    # Podio.client.oauth_token = Podio::OAuthToken.new('access_token' => '30da4594eef93528c11df7fb5deb989cd629ea7060a1ce1ced628d19398214c942bcfe0334cf953ef70a80ea1afdfd80183d5c75d19c1f5526ca4c6f6f3471ef', 'refresh_token' => '82e7a11ae187f28a25261599aa6229cd89f8faee48cba18a75d70efae88ba665ced11d43143b7f5bebb31a4103662b851dd2db1879a3947b843259479fccfad3', 'expires_in' => -10)

    login_as(:professor)
    Podio.client.reset

    assert_nothing_raised do
      response = Podio.connection.get("/org/")
      assert_equal 200, response.status
    end
  end

  test 'setting the oauth_token should reconfigure the connection' do
    podio = Podio::Client.new
    assert_nil podio.connection.headers['authorization']

    podio.oauth_token = Podio::OAuthToken.new('access_token' => 'access', 'refresh_token' => 'refresh')
    assert_equal 'OAuth2 access', podio.connection.headers['authorization']
  end

  test 'setting the oauth_token as a hash should reconfigure the connection' do
    podio = Podio::Client.new
    assert_nil podio.connection.headers['authorization']

    podio.oauth_token = {'access_token' => 'access', 'refresh_token' => 'refresh'}
    assert_equal 'OAuth2 access', podio.connection.headers['authorization']
  end

  test 'should allow to modify the request using before request hooks' do
    login_as(:professor)
    Podio::Hooks.add_before_request_hook do |env|
      env[:request_headers][:hook] = "true"
    end

    podio = Podio::Client.new
    assert_nil podio.connection.headers['Hook']

    response = Podio.connection.get("/org/")
    assert_equal "true", response.env[:request_headers]['Hook']
  end

  test 'should be able to make arbitrary requests' do
    login_as(:professor)
    response = Podio.connection.get("/org/")
    assert_equal 200, response.status
    assert response.body.is_a?(Array)
  end
end
