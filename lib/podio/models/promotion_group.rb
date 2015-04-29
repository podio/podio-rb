class Podio::PromotionGroup < ActivePodio::Base

  property :promotion_group_id, :integer
  property :name, :string
  property :description, :string
  property :status, :string

  alias_method :id, :promotion_group_id

  class << self

    def find_all(options={})
      list Podio.connection.get { |req| 
        req.url("/promotion_group/", options)
      }.body
    end

    def find(promotion_group_id)
      member Podio.connection.get("/promotion_group/#{promotion_group_id}").body
    end

    def create(attributes)
      member Podio.connection.post { |req| 
        req.url("/promotion_group/")
        req.body = attributes
      }.body
    end

    def update(promotion_group_id, attributes)
      puts promotion_group_id, attributes
      member Podio.connection.put { |req|
        req.url("/promotion_group/#{promotion_group_id}")
        req.body = attributes
      }.body
    end

    def enable(promotion_group_id)
      member Podio.connection.post("/promotion_group/#{promotion_group_id}/enable").body
    end

    def disable(promotion_group_id)
      member Podio.connection.post("/promotion_group/#{promotion_group_id}/disable").body
    end

    def delete(promotion_group_id)
      Podio.connection.delete("/promotion_group/#{promotion_group_id}")
    end

  end

end