class Podio::ContractPrice < ActivePodio::Base
  property :total, :float

  has_many :users, :class => 'ContractUser'

  def premium_employees
    users.select { |u| u['items']['employee'].present? }
  end

  def emp_network_employees
    users.select { |u| u['items']['emp_network'].present? }
  end

  def premium_employees?
    items['employee'].present?
  end

  def total_for_premium_employees
    items['employee']['sub_total']
  end

  def emp_network?
    items['emp_network'].present?
  end

  def items
    if @items.nil?
      @items = {}
      self[:items].each do |key, attributes|
        @items[key] = Podio::ContractPriceItem.new(attributes)
      end
    end
    @items
  end

end

class Podio::ContractPriceItem < ActivePodio::Base
  property :sub_total, :float
  property :quantity, :integer
  property :already_paid, :integer
end
