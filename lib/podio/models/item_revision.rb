class Podio::ItemRevision < ActivePodio::Base
  property :revision, :integer
  property :app_revision, :integer
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  
  class << self
    def find(item_id, revision_id)
      member Podio.connection.get("/item/#{item_id}/revision/#{revision_id}").body
    end

    def find_all_by_item_id(item_id)
      list Podio.connection.get("/item/#{item_id}/revision/").body
    end
  end
end