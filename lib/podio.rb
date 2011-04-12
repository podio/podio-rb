require 'faraday'
require 'active_support/core_ext'

require 'podio/middleware/json_request'
require 'podio/middleware/date_conversion'
require 'podio/middleware/logger'
require 'podio/middleware/oauth2'
require 'podio/middleware/podio_api'
require 'podio/middleware/json_response'
require 'podio/middleware/error_response'
require 'podio/middleware/response_recorder'

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

    def client
      Thread.current[:podio_client] ||= Podio::Client.new
    end

    def client=(new_client)
      Thread.current[:podio_client] = new_client
    end

    def connection
      client.connection
    end
  end

  class StdoutLogger
    def initialize(debug)
      @debug = debug
    end

    def log(env)
      begin
        puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n" if @debug
        yield
      ensure
        puts "\n== (#{env[:status]}) ==> #{env[:body]}\n\n" if @debug
      end
    end
  end

  class OAuthToken < Struct.new(:access_token, :refresh_token, :expires_at)
    def initialize(params = {})
      self.access_token = params['access_token']
      self.refresh_token = params['refresh_token']
      self.expires_at = Time.now + params['expires_in'] if params['expires_in']
    end
  end

  autoload :Client,             'podio/client'
  autoload :Error,              'podio/error'
  autoload :ResponseWrapper,    'podio/response_wrapper'

  autoload :Application,        'podio/areas/application'
  autoload :Bulletin,           'podio/areas/bulletin'
  autoload :Category,           'podio/areas/app_store'
  autoload :Comment,            'podio/areas/comment'
  autoload :Connection,         'podio/areas/connection'
  autoload :Contact,            'podio/areas/contact'
  autoload :Conversation,       'podio/areas/conversation'
  autoload :File,               'podio/areas/file'
  autoload :Form,               'podio/areas/form'
  autoload :Item,               'podio/areas/item'
  autoload :Integration,        'podio/areas/integration'
  autoload :Organization,       'podio/areas/organization'
  autoload :OrganizationMember, 'podio/areas/organization_member'
  autoload :OrganizationProfile, 'podio/areas/organization_profile'
  autoload :Rating,             'podio/areas/rating'
  autoload :Search,             'podio/areas/search'
  autoload :Space,              'podio/areas/space'
  autoload :SpaceInvite,        'podio/areas/space'
  autoload :SpaceMember,        'podio/areas/space'
  autoload :Status,             'podio/areas/status'
  autoload :StoreShare,         'podio/areas/store'
  autoload :Task,               'podio/areas/task'
  autoload :TaskLabel,          'podio/areas/task'
  autoload :User,               'podio/areas/user'
  autoload :UserStatus,         'podio/areas/user_status'
  autoload :Widget,             'podio/areas/widget'
end
