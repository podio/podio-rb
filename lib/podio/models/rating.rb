class Podio::Rating < ActivePodio::Base
  
  class << self
    def create(ref_type, ref_id, rating_type, value)
      response = Podio.connection.post do |req|
        req.url "/rating/#{ref_type}/#{ref_id}/#{rating_type}"
        req.body = { :value => value }
      end

      response.body['rating_id']
    end

    def find_all(ref_type, ref_id)
      collection Podio.connection.get("/rating/#{ref_type}/#{ref_id}").body
    end
    
    def find(ref_type, ref_id, rating_type, user_id)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}/#{user_id}").body['value']
    end

    def find_own(ref_type, ref_id, rating_type)
      Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}/self").body['value']
    end

    def find_all_by_type(ref_type, ref_id, rating_type)
      collection Podio.connection.get("/rating/#{ref_type}/#{ref_id}/#{rating_type}").body
    end

    def delete(ref_type, ref_id, rating_type)
      Podio.connection.delete("/rating/#{ref_type}/#{ref_id}/#{rating_type}").body
    end
  end
  
end