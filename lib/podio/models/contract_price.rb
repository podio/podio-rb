class Podio::ContractPrice < ActivePodio::Base

  has_one :employee, :class => 'ContractPriceItem'
  has_one :external, :class => 'ContractPriceItem'
  has_one :item,     :class => 'ContractPriceItem'

  def total
    self.employee.sub_total + self.external.sub_total
  end

  class << self
    def calculate(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/price"
        req.body = attributes
      end

      member response.body
    end

  end
end

class Podio::ContractPriceItem < ActivePodio::Base
  property :price, :float # Price per user
  property :quantity, :integer # Number of users

  def sub_total
    if self.quantity
      (self.quantity*self.price).to_f
    else
      0.to_f
    end
  end

end
