class Podio::NetPromoterScore < ActivePodio::Base
  property :nps_id, :integer
  property :user_id, :integer
  property :created_on, :datetime
  property :created_via, :integer
  property :score, :integer
  property :feedback, :string
  property :country_code, :string

  alias_method :id, :nps_id

  class << self
    def create(attributes=[])
      member Podio.connection.post { |req|
        req.url("/nps/")
        req.body = attributes
      }.body
    end

    def update(nps_id, attributes)
      member Podio.connection.put { |req|
        req.url("/nps/#{nps_id}")
        req.body = attributes
      }.body
    end
  end

end
