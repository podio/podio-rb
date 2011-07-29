class Podio::Search < ActivePodio::Base
  
  class << self
    def in_org(org_id, words)
      response = Podio.connection.post do |req|
        req.url "/search/org/#{org_id}/"
        req.body = words
      end

      list response.body
    end    

    def in_space(space_id, words)
      response = Podio.connection.post do |req|
        req.url "/search/space/#{space_id}/"
        req.body = words
      end

      list response.body
    end    
  end
  
end