class Podio::Notification < ActivePodio::Base
  property :notification_id, :integer
  property :user, :hash
  property :type, :string
  property :viewed_on, :datetime
  property :subscription_id, :integer
  property :created_on, :datetime
  property :data, :hash
  property :starred, :boolean

  # Only available when getting a single notification
  property :space, :hash
  property :org, :hash
  property :data_link, :string
  property :context_type, :string
  property :context_link, :string
  property :context, :hash

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_one :user, :class => 'User'

  alias_method :id, :notification_id
  delegate_to_hash :data, :field, :value, :role, :message
  
  class << self
    def find(id)
      member Podio.connection.get("/notification/#{id}").body
    end

    def mark_as_viewed(id)
      Podio.connection.post("/notification/#{id}/viewed").status
    end

    def mark_all_as_viewed
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
