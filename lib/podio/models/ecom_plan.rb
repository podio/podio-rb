class Podio::EcomPlan < ActivePodio::Base
  property :product_code, :string
  property :product_name, :string
  property :min_qty, :integer
  property :monthly_price, :float
  property :annually_price, :float

  class << self

    def all
      collection get_plans.values.map(&:plan_difinition_to_hash)
    end

    def find(tier)
      member plan_difinition_to_hash get_plan_by_tier(tier)
    end

    private

    def get_plans
      Contract.get_ecom_prices.deep_symbolize_keys
    end

    def get_plan_by_tier(tier)
      get_plans[tier.to_sym]
    end

    def plan_difinition_to_hash(plan_difinition)
      plans_copy = plan_difinition.clone

      plans_copy.slice(:product_code, :product_name, :min_qty).merge({
        monthly_price: plan_difinition[:monthly][:pricePerUser],
        annually_price: plan_difinition[:annually][:pricePerUser]
      })
    end
  end
end
