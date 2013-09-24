class Podio::ContractEvent < ActivePodio::Base
  property :type, :string
  property :created_on, :datetime
  
  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  class << self
    # @see https://hoist.podio.com/api/apps/apioperations/items/699
    def find_all_for_contract(contract_id, options = {})
      list Podio.connection.get { |req|
        req.url("/contract/#{contract_id}/event/", options)
      }.body
    end
    
  end
end
