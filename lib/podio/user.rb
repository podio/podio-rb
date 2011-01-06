module Podio
  module User
    include Podio::ResponseWrapper
    extend self

    def current
      member Podio.connection.get("/user/status").body['user']
    end

  end
end