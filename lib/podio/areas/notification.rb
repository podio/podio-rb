module Podio
  module Notification
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/notification/#{id}").body
    end

    def mark_as_viewed(id)
      Podio.connection.post("/notification/#{id}/viewed").status
    end

    def mark_all_as_viewed(id)
      Podio.connection.post("/notification/viewed").status
    end
    
    def star(id)
      Podio.connection.post("/notification/#{id}/star").status
    end

    def unstar(id)
      Podio.connection.delete("/notification/#{id}/star").status
    end
    
  end
  
  module NotificationGroup
    include Podio::ResponseWrapper
    extend self
    
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/notification/', options)
      }.body
    end
  end
end

