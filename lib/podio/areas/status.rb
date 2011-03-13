module Podio
  module Status
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/status/#{id}").body
    end
  end
end
