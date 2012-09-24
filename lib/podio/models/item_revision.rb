# @see https://developers.podio.com/doc/items
class Podio::ItemRevision < ActivePodio::Base
  property :revision, :integer
  property :app_revision, :integer
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  class << self
    # @see https://developers.podio.com/doc/items/get-item-revision-22373
    def find(item_id, revision_id)
      member Podio.connection.get("/item/#{item_id}/revision/#{revision_id}").body
    end

    # @see https://developers.podio.com/doc/items/get-item-revisions-22372
    def find_all_by_item_id(item_id)
      list Podio.connection.get("/item/#{item_id}/revision/").body
    end
  end
end
