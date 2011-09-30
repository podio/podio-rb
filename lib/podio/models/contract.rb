class Podio::Contract < ActivePodio::Base
  include ActivePodio::Updatable

  property :contract_id, :integer
  property :org_id, :integer
  property :status, :string
  property :created_on, :datetime
  property :started_on, :datetime
  property :ended_on, :datetime
  property :item_prices, :hash
  property :payment_id, :string
  property :accounting_id, :string
  property :full, :boolean
  property :premium_emp_network, :boolean
  property :premium_spaces, :array
  property :next_period_start, :datetime, :convert_timezone => false
  property :next_period_end, :datetime, :convert_timezone => false
  property :invoice_interval, :integer
  property :invoicing_mode, :string

  has_one :org, :class => 'Organization'
  has_one :user, :class => 'User'
  has_one :price, :class => 'ContractPrice'
  has_many :premium_spaces, :class => 'Space'

  alias_method :id, :contract_id

  def update
    self.class.update(self.contract_id, self.attributes)
  end

  def calculate_price
    pricing = self.class.calculate_price(self.contract_id, self.attributes.slice(:full, :premium_emp_network, :premium_spaces))
    self["price"] = pricing
  end

  def create_payment(query_string)
    self.class.create_payment(self.contract_id, query_string)
  end

  handle_api_errors_for :update, :create_payment # Call must be made after the methods to handle have been defined

  class << self
    def find(contract_id)
      member Podio.connection.get("/contract/#{contract_id}").body
    end

    def find_all_mine
      list Podio.connection.get("/contract/").body
    end

    def find_for_org(org_id)
      list Podio.connection.get("/contract/org/#{org_id}/").body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/"
        req.body = attributes
      end

      member response.body
    end

    def update(contract_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/contract/#{contract_id}"
        req.body = attributes
      end
      response.status
    end

    def start(contract_id)
      Podio.connection.post("/contract/#{contract_id}/start").body
    end

    def delete(id)
      Podio.connection.delete("/contract/#{id}").body
    end

    def calculate_price(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/price"
        req.body = attributes
      end

      response.body
    end

    def create_payment(contract_id, query_string)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/payment"
        req.body = {:query_string => query_string}
      end

      response.body
    end
  end
end
