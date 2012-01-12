class Podio::ItemField < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :string
  property :label, :string
  property :values, :array

  alias_method :id, :field_id
  
  class << self
    def update(item_id, field_id, values)
      response = Podio.connection.put do |req|
        req.url "/item/#{item_id}/value/#{field_id}"
        req.body = values
      end
      response.body
    end    
  end
end