require 'test_helper'

class ClientTest < Test::Unit::TestCase
  test 'should setup client' do
    Podio.setup(:api_key => 'client_id', :api_secret => 'client_secret')
  
    assert_equal Podio::Client, Podio.client.class
    assert_equal 'client_id', Podio.client.api_key
    assert_equal 'client_secret', Podio.client.api_secret

    assert_equal 'Basic Y2xpZW50X2lkOmNsaWVudF9zZWNyZXQ=', Podio.client.connection.headers['authorization']
  end

  test 'should initialize client' do
    podio = Podio::Client.new()

    assert_equal 'https://api.podio.com', podio.api_url
    assert_nil podio.connection.headers['authorization']
  end

  test 'should initialize client with key and secret' do
    podio = Podio::Client.new(:api_url => 'https://new.podio.com', :api_key => 'new_client_id', :api_secret => 'new_client_secret')
  
    assert_equal 'https://new.podio.com', podio.api_url
    assert_equal 'new_client_id', podio.api_key
    assert_equal 'new_client_secret', podio.api_secret

    assert_equal 'Basic bmV3X2NsaWVudF9pZDpuZXdfY2xpZW50X3NlY3JldA==', podio.connection.headers['authorization']
  end
  
  test 'should setup connection with existing token' do
    token = Podio::OAuthToken.new('access_token' => 'access', 'refresh_token' => 'refresh')
    podio = Podio::Client.new(:oauth_token => token)
  
    assert_equal token, podio.oauth_token
  
    assert_equal 'OAuth2 access', podio.connection.headers['authorization']
  end
  
  test 'should get an access token' do
    Podio.client.stubs.post('/oauth/token') {[200, {}, {"access_token" => "a3345189a07b478284356c8b0b3c54d5", "expires_in" => 28799, "refresh_token" => "cdca6acfeb374598ba2790c9e5283b21"}]}

    client = Podio.client
    client.oauth_token = nil
    assert_nil client.oauth_token

    user = fixtures[:users][:professor]
    client.authenticate_with_credentials(user[:mail], user[:password])
  
    assert_not_nil client.oauth_token.access_token
    assert_not_nil client.oauth_token.refresh_token
  end

  test 'should be able to refresh access token' do
    Podio.client.stubs.post('/oauth/token') {[200, {}, {"access_token" => "a3345189a07b478284356c8b0b3c54d5", "expires_in" => 28799, "refresh_token" => "cdca6acfeb374598ba2790c9e5283b21"}]}

    login_as(:fry)
    client = Podio.client
    old_token = client.oauth_token.dup

    Podio.client.stubs.post('/oauth/token') {[200, {}, {"access_token" => "efb7614007ae426481de69310ec14953", "expires_in" => 28799, "refresh_token" => "cdca6acfeb374598ba2790c9e5283b21"}]}

    client.refresh_access_token

    assert_not_equal old_token.access_token, client.oauth_token.access_token
    assert_equal old_token.refresh_token, client.oauth_token.refresh_token
  end

  test 'should automatically refresh an expired token' do
    Podio.client.stubs.post('/oauth/token') {[200, {}, {"access_token" => "a3345189a07b478284356c8b0b3c54d5", "expires_in" => 28799, "refresh_token" => "cdca6acfeb374598ba2790c9e5283b21"}]}

    login_as(:professor)
    Podio.client.reset

    Podio.client.stubs.get('/org/') {[200, {}, [{"status" => "active"}]]}

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

  test 'should be able to make arbitrary requests' do
    login_as(:professor)

    Podio.client.stubs.get('/org/') {[200, {}, [{"status" => "active"}]]}

    response = Podio.connection.get("/org/")
    assert_equal 200, response.status
    assert response.body.is_a?(Array)
  end
end
