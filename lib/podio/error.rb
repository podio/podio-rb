module Podio
  class PodioError < StandardError
    attr_reader :response_body, :response_status, :url

    def initialize(response_body, response_status, url)
      @response_body, @response_status, @url = response_body, response_status, url

      super(response_body.inspect)
    end
  end

  class TokenExpired < PodioError; end
  class AuthorizationError < PodioError; end
  class BadRequestError < PodioError; end
  class ServerError < PodioError; end
  class NotFoundError < PodioError; end
  class ConflictError < PodioError; end
  class GoneError < PodioError; end
  class UnavailableError < PodioError; end
end
