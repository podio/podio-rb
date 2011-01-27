module Podio
  module Error
    class TokenExpired < StandardError; end
    class AuthorizationError < StandardError; end
    class BadRequestError < StandardError; end
    class ServerError < StandardError; end
    class NotFoundError < StandardError; end
    class GoneError < StandardError; end
    class Unavailable < StandardError; end
  end
end
