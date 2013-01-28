class Podio::ContractPriceV2 < ActivePodio::Base

  has_one :employee, :class => 'ContractPriceItemV2'
  has_one :external, :class => 'ContractPriceItemV2'

  class << self
    def calculate(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/price/v2"
        req.body = attributes
      end

      member response.body
    end

  end
end

class Podio::ContractPriceItemV2 < ActivePodio::Base
  property :price, :float # Price per user
  property :quantity, :integer # Number of users
end
