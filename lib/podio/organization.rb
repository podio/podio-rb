module Podio
  module Organization
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/org/#{id}").body
    end
  end
end
