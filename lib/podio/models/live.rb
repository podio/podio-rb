class Podio::Live < ActivePodio::Base

  class << self

    # @see https://hoist.podio.com/api/item/45673217
    def create(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/live/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      member response.body
    end

  end
  
end