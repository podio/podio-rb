module Podio
  module Email
    include Podio::ResponseWrapper
    extend self

    def unsubscribe(mailbox)
      Podio.connection.post("/email/unsubscribe/#{mailbox}").status
    end
  end
end
