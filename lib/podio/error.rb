module Podio
  class PodioError < StandardError
    attr_reader :response_body, :response_status, :url, :code, :sub_code, :message, :propagate, :parameters

    def initialize(response_body, response_status, url)
      @response_body, @response_status, @url = response_body, response_status, url

      if response_body.is_a?(Hash)
        @code       = response_body["error"]
        @sub_code   = response_body["error_detail"]
        @message    = response_body["error_description"]
        @propagate  = response_body["error_propagate"]
        @parameters = response_body["error_parameters"]
      else
        @message    = response_body.to_s
      end

      super(response_body.inspect)
    end
    
    def resolved_message(default_message=nil)
      if @propagate
        @message
      else
        default_message || "An unexpected error occurred"
      end
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
  class RequestableAuthorizationError < AuthorizationError; end
end
