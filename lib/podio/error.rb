module Podio
  module Error
    class PodioError < StandardError; end

    class TokenExpired < PodioError; end
    class AuthorizationError < PodioError; end
    class BadRequestError < PodioError; end
    class ServerError < PodioError; end
    class NotFoundError < PodioError; end
    class ConflictError < PodioError; end
    class GoneError < PodioError; end
    class Unavailable < PodioError; end
  end
end
