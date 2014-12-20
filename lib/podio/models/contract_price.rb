class Podio::ContractPrice < ActivePodio::Base

  has_one :employee, :class => 'ContractPriceItem'
  has_one :external, :class => 'ContractPriceItem'
  has_one :item,     :class => 'ContractPriceItem'
  
  def mrr_saved
    self.employee.mrr_saved + self.external.mrr_saved
  end
  
  def mrr_list
    self.employee.mrr_list + self.external.mrr_list
  end

  def mrr
    self.employee.mrr + self.external.mrr
  end

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
  property :list_price, :float #The list price per user
  property :price, :float # Price per user
  property :price_rebate, :float # The rebate on the price
  property :quantity, :integer # Number of users
  property :mrr_saved, :float #The MRR saved 
  property :mrr_list, :float #The MRR based on the list price
  property :mrr, :float #The MRR on the rebated price

  def sub_total
    if self.quantity
      (self.quantity*self.price).to_f
    else
      0.to_f
    end
  end

end
