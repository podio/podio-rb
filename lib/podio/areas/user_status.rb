module Podio
  module UserStatus
    include Podio::ResponseWrapper
    extend self

    def current
      member Podio.connection.get("/user/status").body
    end

  end
end