# @see https://developers.podio.com/doc/items
class Podio::ItemField < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :string
  property :label, :string
  property :values, :array
  property :config, :hash

  alias_method :id, :field_id

  class << self
    # @see https://developers.podio.com/doc/items/update-item-field-values-22367
    def update(item_id, field_id, values, options = {})
      response = Podio.connection.put do |req|
        req.url("/item/#{item_id}/value/#{field_id}", options)
        req.body = values
      end
      response.body
    end

    # @see https://developers.podio.com/doc/calendar/get-item-field-calendar-as-ical-10195681
    def ical_entry(item_id, field_id)
      Podio.connection.get("/calendar/item/#{item_id}/field/#{field_id}/ics/").body
    end

    # @see https://developers.podio.com/doc/items/get-field-ranges-24242866
    def get_field_ranges(field_id)
      Podio.connection.get("/item/field/#{field_id}/range").body
    end

  end
end
