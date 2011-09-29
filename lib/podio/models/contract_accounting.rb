class Podio::ContractAccounting < ActivePodio::Base
  include ActivePodio::Updatable

  property :contract_id, :integer
  property :first_name, :string
  property :last_name, :string
  property :organization, :string
  property :phone, :string
  property :address1, :string
  property :address2, :string
  property :zip, :string
  property :city, :string
  property :state, :string
  property :country, :string

  def update
    self.class.update(self.contract_id, self.attributes)
  end

  class << self
    def find(contract_id)
      member Podio.connection.get("/contract/#{contract_id}/accounting").body
    end

    def update(contract_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/contract/#{contract_id}/accounting"
        req.body = attributes
      end
      response.status
    end
  end
end
