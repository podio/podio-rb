class Podio::EmailSubscriptionSetting < ActivePodio::Base
  include ActivePodio::Updatable

  property :digest, :boolean
  property :bulletin, :boolean
  property :reference, :boolean
  property :message, :boolean
  property :space, :boolean
  property :subscription, :boolean

  def self.find_for_current_user
    self.get_groups
  end
  
  def update
    self.class.update_groups(self.attributes)
  end
  
  class << self
    def get_groups()
      member Podio.connection.get { |req|
        req.url("/email/group/", {})
      }.body
    end

    def update_groups(options)
      Podio.connection.put { |req|
        req.url "/email/group/"
        req.body = options
      }.body
    end

    def unsubscribe(username)
      Podio.connection.post("/email/unsubscribe/#{username}").status
    end
    
  end

end
