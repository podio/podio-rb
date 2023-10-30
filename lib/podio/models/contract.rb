class Podio::Contract < ActivePodio::Base
  include ActivePodio::Updatable

  property :contract_id, :integer
  property :org_id, :integer
  property :status, :string
  property :blocked, :boolean
  property :created_on, :datetime
  property :started_on, :datetime
  property :reconciled_until, :datetime
  property :created_via, :string
  property :ended_on, :datetime
  property :item_prices, :hash
  property :item_limits, :hash
  property :payment_id, :string
  property :payment_status, :string
  property :payment_provider, :string
  property :accounting_id, :string
  property :accounting_provider, :string
  property :full, :boolean
  property :premium_emp_network, :boolean
  property :premium_spaces, :array
  property :premium_space_ids, :array
  property :next_period_start, :datetime, :convert_timezone => false
  property :next_period_end, :datetime, :convert_timezone => false
  property :invoice_interval, :integer
  property :invoicing_mode, :string
  property :ended_reason, :string
  property :ended_comment, :string
  property :billing_mail, :string
  property :model, :string
  property :unpaid_due_date, :datetime
  property :count_employee, :integer
  property :count_external, :integer
  property :yearly_rebate_factor, :decimal
  property :mrr, :decimal
  property :days_overdue, :integer
  property :overdue_status, :string
  property :tier, :string
  property :effective_cancellation_date, :date
  property :force_cancellation_date, :date
  property :contract_was_migrated, :boolean

  has_one :org, :class => 'Organization'
  has_one :user, :class => 'User'
  has_one :sold_by, :class => 'User'
  has_one :price, :class => 'ContractPrice'
  has_many :premium_spaces, :class => 'Space'

  alias_method :id, :contract_id

  def price=(attributes)
    self[:price] = attributes
  end

  def premium_space_ids=(values)
    self[:premium_space_ids] = (values || []).map(&:to_i)
  end

  def update
    self.class.update(self.contract_id, self.attributes.except(:premium_spaces))
  end

  def calculate_price
    pricing = self.class.calculate_price(self.contract_id, self.attributes.slice(:full, :premium_emp_network, :premium_space_ids))
    self.clear_price
    self["price"] = pricing
  end

  def create_payment(query_string)
    self.class.create_payment(self.contract_id, query_string)
  end

  def delete
    self.class.delete(self.id)
  end

  def end(attributes)
    self.class.end(self.id, attributes)
  end

  def end_non_payment(attributes)
   self.class.end_non_payment(self.id, attributes)
  end

  def end_offline_sfdc(attributes)
    self.class.end_offline_sfdc(self.id, attributes)
  end

  def change_to_fixed
    self.class.change_to_fixed(self.contract_id,
      :item_limits => {
        :employee => self.item_limits['employee'],
        :external => self.item_limits['external']
      },
      :invoice_interval => self.invoice_interval
    )
  end

  def change_to_variable
    self.class.change_to_variable(self.contract_id)
  end

  def block
    self.class.block(self.contract_id)
  end

  def unblock
    self.class.unblock(self.contract_id)
  end

  def tier_prices
    self.class.get_tier_prices(self.contract_id)
  end

  class << self

    def find(contract_id, options={})
      member Podio.connection.get("/contract/#{contract_id}", options).body
    end

    def find_non_payment_org(user_id, options={})
      member Podio.connection.get("/contract/#{user_id}/get_payment_pending_org", options).body
    end

    def find_all_mine
      list Podio.connection.get("/contract/").body
    end

    def find_all_my_offers
      list Podio.connection.get("/contract/offered/").body
    end

    def find_for_org(org_id)
      list Podio.connection.get("/contract/org/#{org_id}/").body
    end

    def find_users_for_org(org_id)
      member Podio.connection.get("/contract/org/#{org_id}/user").body
    end

    def find_all_unpaid
      list Podio.connection.get("/contract/unpaid/").body
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

    def end(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/end"
        req.body = attributes
      end

      response.body
    end

    def end_non_payment(non_payment_contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{non_payment_contract_id}/flip_from_offline"
        req.body = attributes
      end

      response.body
    end

    def end_offline_sfdc(contract_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/contract/#{contract_id}/external/cancel"
        req.body = attributes
      end

      response.body
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

    def change_to_fixed(contract_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/contract/#{contract_id}/change_to/fixed"
        req.body = attributes
      end

      response.status
    end

    def change_to_variable(contract_id)
      response = Podio.connection.post("/contract/#{contract_id}/change_to/variable")
      response.status
    end

    def block(contract_id)
      response = Podio.connection.post("/contract/#{contract_id}/block")
      response.status
    end

    def unblock(contract_id)
      response = Podio.connection.post("/contract/#{contract_id}/unblock")
      response.status
    end

    def get_tier_prices(contract_id)
      Podio.connection.get("/contract/#{contract_id}/price/tier").body
    end

    def get_ecom_prices
      Podio.connection.get('/contract/plans/ecom').body
    end

    def get_list_prices
      Podio.connection.get('/contract/price/').body
    end

    #=============================================================
    # Fetches available tier plan names from backend
    # Returns tier/plan names as active/deprecated/default plans in json format
    # Params: (optional) array of plan names
    #=============================================================
    # FIXME:: For some reason without explicit public automation throws
    #         private method error
    public
    def get_plan_names
      Podio.connection.get('/contract/plan_names').body
    end

    #=============================================================
    # Fetches available tier plan prices from backend,
    # if no or empty plans are provided
    #
    # Returns deprecated tier/plan price details as json
    # Params: (optional) array of plan names
    #=============================================================
    def get_active_list_prices(list_prices={})
      list_prices = get_list_prices if list_prices.empty?

      list_prices.select {|_, data| data['deprecated'] == false }
    end

    #=============================================================
    # Fetches available tier plan prices from backend,
    # if no or empty plans are provided
    #
    # Returns default tier/plan price details as json
    # Params: (optional) array of plan names
    #=============================================================
    def get_default_list_price(list_prices={})
      list_prices = get_list_prices if list_prices.empty?

      list_prices.select {|_, data| data["default"] == true }
    end

    #=============================================================
    # Fetches available tier names from backend, if no or empty plans are provided
    # Returns default tier/plan name
    # Params: (optional) array of plan names
    #=============================================================
    def get_default_tier(tiers=[])
      tiers = get_plan_names if tiers.empty?

      tiers.present? ? tiers["default"] : ""
    end

    #=============================================================
    # Fetches currently valid/active tier plans in backend
    # Returns an array of plan names
    # Params: None
    #=============================================================
    def valid_tiers
      tiers = get_plan_names

      tiers.present? ? tiers["active"] : []
    end

    #=============================================================
    # Validates if a tier is valid with available plans in backend
    # Returns a boolean value
    # Params: name of tier
    #=============================================================
    def valid_tier?(tier)
      valid_tiers.include?(tier)
    end
  end
end
