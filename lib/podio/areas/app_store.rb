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
end
