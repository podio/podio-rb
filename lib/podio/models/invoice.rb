class Podio::Invoice < ActivePodio::Base
  property :invoice_id, :string
  property :number, :string
  property :date, :datetime
  property :due_date, :datetime
  property :amount, :float
  property :amount_due, :float
  property :amount_paid, :float
  property :status, :string

  alias_method :id, :invoice_id

  class << self
    def find(invoice_id)
      member Podio.connection.get("/invoice/#{invoice_id}").body
    end

    def get_as_pdf(invoice_id)
      Podio.client.connection.get("/invoice/#{invoice_id}/pdf").body
    end

    def find_by_contract(contract_id)
      list Podio.connection.get("/invoice/contract/#{contract_id}/").body
    end
    
    def invoice_contract(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/invoice/contract/#{contract_id}/invoice"
        req.body = attributes
      end
      
      if response.status == 200
        member response.body
      else
        nil
      end
    end

    def pay(invoice_id)
      Podio.connection.post("/invoice/#{invoice_id}/pay").status
    end
  end
end
