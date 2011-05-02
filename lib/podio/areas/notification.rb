module Podio
  module Notification
    include Podio::ResponseWrapper
    extend self

    def find(id)
      member Podio.connection.get("/notification/#{id}").body
    end

    # Returns a hash of notifications grouped around the same context. Notifications are instansiated as object, everything else is preserved as returned from the API.
    def find_all(options={})
      groups = Podio.connection.get { |req|
        req.url('/notification/', options)
      }.body
      
      groups.collect do |group|
        group['notifications'].collect! { |notification| self.new(notification) }
        group
      end
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

end

