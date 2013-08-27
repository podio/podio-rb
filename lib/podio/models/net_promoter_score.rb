class Podio::NetPromoterScore < ActivePodio::Base
  property :nps_id, :integer
  property :user_id, :integer
  property :created_on, :datetime
  property :created_via, :integer
  property :score, :integer
  property :feedback, :string
  property :country_code, :string

  class << self
    def create(attributes=[])
      response = Podio.connection.post do |req|
        req.url "/nps/"
        req.body = attributes
      end

      response.body['nps_id']
    end
  end

end
