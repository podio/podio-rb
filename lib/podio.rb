require 'faraday'

module Podio
  class << self
    attr_accessor :api_key
    attr_accessor :api_secret
    attr_accessor :api_url
    attr_accessor :debug

    def configure
      yield self
      true
    end
  end

  class OAuthToken < Struct.new(:access_token, :refresh_token, :expires_at)
    def initialize(params = {})
      self.access_token = params['access_token']
      self.refresh_token = params['refresh_token']
      self.expires_at = Time.now + params['expires_in'] if params['expires_in']
    end
  end

  module Error
    class TokenExpired < StandardError; end
    class AuthorizationError < StandardError; end
    class ServerError < StandardError; end
    class NotFoundError < StandardError; end
  end
end

require 'podio/client'
