# @see https://developers.podio.com/doc/oauth-authorization
class Podio::OAuth < ActivePodio::Base

  class << self
    def authorize(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/authorize"
        req.body = attributes
      end

      response.body
    end

    def get_info(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/info"
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/oauth-authorization/get-access-token-22359
    def get_access_token(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/token"
        req.body = attributes
      end

      response.body
    end
  end

end
