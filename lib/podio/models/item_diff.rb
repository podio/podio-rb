# @see https://developers.podio.com/doc/items
class Podio::ItemDiff < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :string
  property :label, :string
  property :config, :hash
  property :from, :array
  property :to, :array

  alias_method :id, :field_id

  class << self
    # @see https://developers.podio.com/doc/items/get-item-revision-difference-22374
    def find_by_item_and_revisions(item_id, revision_from_id, revision_to_id)
      list Podio.connection.get("/item/#{item_id}/revision/#{revision_from_id}/#{revision_to_id}").body
    end

    # @see https://developers.podio.com/doc/items/revert-item-revision-953195
    def revert(item_id, revision_id)
      Podio.connection.delete("/item/#{item_id}/revision/#{revision_id}").body
    end
  end
end
