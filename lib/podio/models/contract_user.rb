class Podio::ContractUser < Podio::User
  property :subtotal, :float
  property :items, :hash
end
