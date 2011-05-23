module Podio
  module Category
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app_store/category/"
        req.body = attributes
      end

      response.status
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/app_store/category/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/app_store/category/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/app_store/category/#{id}").body
    end

    def find_all
      collection Podio.connection.get("/app_store/category/").body
    end

  private

    def self.collection(response)
      return Struct.new(:functional, :vertical).new([], []) if response.blank?
      functionals = response['functional'].map! { |cat| member(cat) }
      verticals   = response['vertical'].map! { |cat| member(cat) }
      Struct.new(:functional, :vertical).new(functionals, verticals)
    end
  end

  module AppStoreShare
    include Podio::ResponseWrapper
    extend self

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/app_store/"
        req.body = attributes
      end

      response.body['share_id']
    end

    def install(share_id, space_id, dependencies)
      response = Podio.connection.post do |req|
        req.url "/app_store/#{share_id}/install/v2"
        req.body = {:space_id => space_id, :dependencies => dependencies}
      end

      response.body
    end

    def find(id)
      member Podio.connection.get("/app_store/#{id}/v2").body
    end

    def find_all_private_for_org(org_id)
      list Podio.connection.get("/app_store/org/#{org_id}/").body['shares']
    end

  end

end
