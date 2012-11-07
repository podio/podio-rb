module Podio
  class PodioError < StandardError
    attr_reader :response_body, :response_status, :url

    def initialize(response_body, response_status, url)
      @response_body, @response_status, @url = response_body, response_status, url

      super(response_body.inspect)
    end
  end

  class TokenExpired < PodioError; end
  class InvalidGrantError < PodioError; end
  class AuthorizationError < PodioError; end
  class BadRequestError < PodioError; end
  class ServerError < PodioError; end
  class NotFoundError < PodioError; end
  class ConflictError < PodioError; end
  class GoneError < PodioError; end
  class RateLimitError < PodioError; end
  class UnavailableError < PodioError; end
  class PaymentRequiredError < AuthorizationError; end

  class RequestableAuthorizationError < AuthorizationError
    attr_reader :request_access_info

    def initialize(response_body, response_status, url)
      @request_access_info = response_body['error_parameters']
      super
    end
  end
end
