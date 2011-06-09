class Podio::ItemDiff < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :integer
  property :label, :string
  property :from, :array
  property :to, :array
  
  class << self
    def find_by_item_and_revisions(item_id, revision_from_id, revision_to_id)
      list Podio.connection.get("/item/#{item_id}/revision/#{revision_from_id}/#{revision_to_id}").body
    end
  end
end