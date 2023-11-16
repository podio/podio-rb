class Podio::EcomPlan < ActivePodio::Base
  property :product_code, :string
  property :product_name, :string
  property :min_qty, :integer
  property :monthly_price, :float
  property :annually_price, :float

  class << self

    def all
      collection get_plans_difinition.values.map(&:plan_difinition_to_hash)
    end

    def find(tier)
      member plan_difinition_to_hash get_plans_difinition[tier.to_sym]
    end

    private

    def get_plans_difinition
      Contract.get_ecom_prices
    end

    def plan_difinition_to_hash(plan_difinition)
      plan_difinition.pluck(:product_code, :product_name, :min_qty).merge({
        monthly_price: plan_difinition[:monthly][:price],
        annually_price: plan_difinition[:annually][:price]
      })
    end
  end
end
