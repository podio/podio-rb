module Podio
  class Client
    attr_reader :api_url, :api_key, :api_secret, :debug, :connection
    attr_accessor :oauth_token, :stubs

    def initialize(options = {})
      @api_url = options[:api_url] || Podio.api_url || 'https://api.podio.com'
      @api_key = options[:api_key] || Podio.api_key
      @api_secret = options[:api_secret] || Podio.api_secret
      @debug = options[:debug] || Podio.debug
      @oauth_token = options[:oauth_token]

      if options[:test_mode]
        @test_mode = true
        @stubs = Faraday::Adapter::Test::Stubs.new
      end
      @connection = configure_connection
      @oauth_connection = configure_oauth_connection
    end

    def get_access_token(username, password)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token', :grant_type => 'password', :client_id => api_key, :client_secret => api_secret, :username => username, :password => password
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    def refresh_access_token
      response = @oauth_connection.post do |req|
        req.url '/oauth/token', :grant_type => 'refresh_token', :refresh_token => oauth_token.refresh_token, :client_id => api_key, :client_secret => api_secret
      end

      @oauth_token.access_token = response.body['access_token']
      configure_oauth
    end

  private

    def configure_connection
      headers = {}
      headers['authorization'] = "OAuth2 #{oauth_token.access_token}" if oauth_token

      Faraday::Connection.new(:url => api_url, :headers => default_headers.merge(headers), :request => {:client => self}) do |builder|
        builder.use Faraday::Request::Yajl
        builder.use Middleware::PodioApi
        builder.use Middleware::OAuth2
        builder.use Middleware::Logger
        builder.adapter(*default_adapter)
        builder.use Middleware::YajlResponse
        builder.use Middleware::ErrorResponse
      end
    end

    def default_adapter
      @test_mode ? [:test, @stubs] : Faraday.default_adapter
    end

    def configure_oauth_connection
      conn = @connection.dup
      conn.options[:client] = self
      conn.headers.delete('authorization')
      conn
    end

    def configure_oauth
      @connection = configure_connection
    end

    def default_headers
      { :user_agent => 'Podio Ruby Library' }
    end
  end
end
