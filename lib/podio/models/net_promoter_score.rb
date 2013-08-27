class Podio::NetPromoterScore < ActivePodio::Base
  property :nps_id, :integer
  property :user_id, :integer
  property :created_on, :datetime
  property :created_via, :integer
  property :score, :integer
  property :feedback, :string
  property :country_code, :string

  class << self
  end

end
