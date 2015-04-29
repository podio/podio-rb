class Podio::PromotionGroupMember < ActivePodio::Base

  property :promotion_group_id, :integer
  property :member_id, :integer

  alias_method :id, :promotion_group_id

  class << self

    def create(attributes)
      member Podio.connection.post { |req| 
        req.url("/promotion_group/#{attributes[:promotion_group_id]}/add")
        req.body = attributes
      }.body
    end

    def find_all(promotion_group_id, options = {})
      Podio.connection.get { |req|
        req.url("/promotion_group/#{promotion_group_id}/members", options)
      }.body
    end

    def add_members(promotion_group_id, attributes)
      Podio.connection.post { |req| 
        req.url "/promotion_group/#{promotion_group_id}/members/add"
        req.body = attributes
      }.status
    end

  end

end