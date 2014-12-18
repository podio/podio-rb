class Podio::ContractPeriod < ActivePodio::Base
  property :start, :datetime
  property :end, :datetime
  property :prices, :hash
  property :quantities, :hash
  property :total_mrr, :decimal
  property :mrr, :hash
  property :rebate, :hash
  property :saved_mrr, :float
  property :list_prices, :hash
  property :invoice_interval, :integer
  property :tier, :string

  has_many :users, :class => 'ContractUser'

  class << self
    def find_all_for_contract(contract_id, start_date, end_date)
      list Podio.connection.get("/contract/#{contract_id}/history", {:start => start_date, :end => end_date}).body
    end
  end

end
