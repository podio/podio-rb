module Podio
  class Client
    attr_reader :api_url, :api_key, :api_secret, :oauth_token, :connection, :trusted_connection
    attr_accessor :stubs, :current_http_client, :headers

    def initialize(options = {})
      @api_url = options[:api_url] || 'https://api.podio.com'
      @api_key = options[:api_key]
      @api_secret = options[:api_secret]
      @logger = options[:logger] || Podio::StdoutLogger.new(options[:debug])
      @oauth_token = options[:oauth_token]
      @headers = options[:custom_headers] || {}
      @adapter = options[:adapter] || Faraday.default_adapter

      if options[:enable_stubs]
        @enable_stubs = true
        @stubs = Faraday::Adapter::Test::Stubs.new
      end
      @test_mode   = options[:test_mode]

      setup_connections
    end

    def log(env, &block)
      @logger.log(env, &block)
    end

    def reset
      setup_connections
    end

    def authorize_url(params={})
      uri = URI.parse(@api_url)
      uri.host  = uri.host.gsub('api.', '')
      uri.path  = '/oauth/authorize'
      uri.query = Rack::Utils.build_query(params.merge(:client_id => api_key))

      uri.to_s
    end

    # sign in as a user using the server side flow
    def authenticate_with_auth_code(authorization_code, redirect_uri)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => 'authorization_code', :client_id => api_key, :client_secret => api_secret, :code => authorization_code, :redirect_uri => redirect_uri}
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    # Sign in as a user using credentials
    def authenticate_with_credentials(username, password)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => 'password', :client_id => api_key, :client_secret => api_secret, :username => username, :password => password}
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    # Sign in as an app
    def authenticate_with_app(app_id, app_token)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => 'app', :client_id => api_key, :client_secret => api_secret, :app_id => app_id, :app_token => app_token}
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    # Sign in with an transfer token, only available for Podio
    def authenticate_with_transfer_token(transfer_token)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => 'transfer_token', :client_id => api_key, :client_secret => api_secret, :transfer_token => transfer_token}
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    # Sign in with SSO
    def authenticate_with_sso(attributes)
      response = @oauth_connection.post do |req|
        req.url '/oauth/token', :grant_type => 'sso', :client_id => api_key, :client_secret => api_secret
        req.body = attributes
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      [@oauth_token, response.body['new_user_created']]
    end

    # Sign in with an OpenID, only available for Podio
    def authenticate_with_openid(identifier, type)
      response = @trusted_connection.post do |req|
        req.url '/oauth/token_by_openid'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => type, :client_id => api_key, :client_secret => api_secret, :identifier => identifier}
      end

      @oauth_token = OAuthToken.new(response.body)
      configure_oauth
      @oauth_token
    end

    # reconfigure the client with a different access token
    def oauth_token=(new_oauth_token)
      @oauth_token = new_oauth_token.is_a?(Hash) ? OAuthToken.new(new_oauth_token) : new_oauth_token
      configure_oauth
    end

    def locale=(new_locale)
      @connection.headers['Accept-Language'] = new_locale
      @oauth_connection.headers['Accept-Language'] = new_locale
      @trusted_connection.headers['Accept-Language'] = new_locale
    end

    def refresh_access_token
      response = @oauth_connection.post do |req|
        req.url '/oauth/token'
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.body = {:grant_type => 'refresh_token', :refresh_token => oauth_token.refresh_token, :client_id => api_key, :client_secret => api_secret}
      end

      @oauth_token = OAuthToken.new(response.body)
      @oauth_token.refreshed = true
      configure_oauth
    end

    def configured_headers
      headers = @headers.dup
      headers['User-Agent'] = "Podio Ruby Library (#{Podio::VERSION})"
      headers['X-Podio-Dry-Run'] = @test_mode.to_s if @test_mode

      if oauth_token
        # if we have a token, set up Oauth2
        headers['authorization'] = "OAuth2 #{oauth_token.access_token}"
      elsif api_key && api_secret
        # if we have an auth_client, set up public authentication (only works with trusted auth clients)
        headers['authorization'] = Faraday::Request::BasicAuthentication.header(api_key, api_secret)
      end

      headers
    end

  private

    def setup_connections
      @connection = configure_connection
      @oauth_connection = configure_oauth_connection
      @trusted_connection = configure_trusted_connection
    end

    def configure_connection
      Faraday::Connection.new(:url => api_url, :headers => configured_headers, :request => {:client => self}) do |builder|
        builder.use Middleware::JsonRequest
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use Middleware::OAuth2
        builder.use Middleware::Logger

        builder.adapter(*default_adapter)

        # first response middleware defined get's executed last
        builder.use Middleware::ErrorResponse
        builder.use Middleware::JsonResponse
      end
    end

    def default_adapter
      @enable_stubs ? [:test, @stubs] : @adapter
    end

    def configure_oauth_connection
      conn = @connection.dup
      conn.options[:client] = self
      conn.headers.delete('authorization')
      conn.headers.delete('X-Podio-Dry-Run') if @test_mode # oauth requests don't really work well in test mode
      conn
    end

    def configure_trusted_connection
      conn = @connection.dup
      conn.options[:client] = self
      conn.headers.delete('authorization')
      conn.basic_auth(api_key, api_secret)
      conn
    end

    def configure_oauth
      @connection = configure_connection
    end
  end
end
