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

      if options[:enable_stubs]
        @enable_stubs = true
        @stubs = Faraday::Adapter::Test::Stubs.new
      end
      @test_mode   = options[:test_mode]
      @record_mode = options[:record_mode]

      setup_connections
    end

    def reset
      setup_connections
    end

    # Sign in as a user
    def get_access_token(username, password)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token', :grant_type => 'password', :client_id => api_key, :client_secret => api_secret, :username => username, :password => password
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end
    
    # Sign in as an app
    def get_access_token_as_app(app_id, app_token)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token', :grant_type => 'app', :client_id => api_key, :client_secret => api_secret, :app_id => app_id, :app_token => app_token
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

    def configured_headers
      headers = {}
      headers['User-Agent']      = 'Podio Ruby Library'
      headers['authorization']   = "OAuth2 #{oauth_token.access_token}" if oauth_token
      headers['X-Podio-Dry-Run'] = '1'                                  if @test_mode

      headers
    end

  private

    def setup_connections
      @connection = configure_connection
      @oauth_connection = configure_oauth_connection
    end

    def configure_connection
      Faraday::Connection.new(:url => api_url, :headers => configured_headers, :request => {:client => self}) do |builder|
        builder.use Middleware::JsonRequest
        builder.use Middleware::PodioApi
        builder.use Middleware::OAuth2
        builder.use Middleware::Logger
        builder.adapter(*default_adapter)
        builder.use Middleware::ResponseRecorder if @record_mode
        builder.use Middleware::JsonResponse
        builder.use Middleware::ErrorResponse
        builder.use Middleware::DateConversion
      end
    end

    def default_adapter
      @enable_stubs ? [:test, @stubs] : Faraday.default_adapter
    end

    def configure_oauth_connection
      conn = @connection.dup
      conn.options[:client] = self
      conn.headers.delete('authorization')
      conn.headers.delete('X-Podio-Dry-Run') if @test_mode # oauth requests don't really work well in test mode
      conn
    end

    def configure_oauth
      @connection = configure_connection
    end
  end
end
