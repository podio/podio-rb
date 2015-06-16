class Podio::ContractAttribution < ActivePodio::Base

  property :contract_id, :integer
  property :name, :string
  property :attribution_id, :string

  alias_method :id, :contract_id

  class << self

    def update(contract_id, partner_id)
      member Podio.connection.put { |req|
        req.url("/contract/attribution/#{contract_id}")
        req.body = {:partner_id => partner_id}
      }.body
    end

  end

end
