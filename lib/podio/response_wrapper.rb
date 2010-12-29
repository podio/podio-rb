module Podio
  module ResponseWrapper
    def member(response)
      response
    end

    def list(response)
      response
    end

    def collection(response)
      Struct.new(:all, :count, :total_count).new(response['items'], response['filtered'], response['total'])
    end
  end
end
