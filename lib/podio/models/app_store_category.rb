class Podio::AppStoreCategory < ActivePodio::Base
  property :category_id, :integer
  property :name, :string
  property :type, :string

  alias_method :id, :category_id

  class << self

    def find(category_id)
      member Podio.connection.get("/app_store/category/#{category_id}").body
    end

    def find_all
      categories = Podio.connection.get("/app_store/category/").body

      categories.each do | key, value |
        categories[key] = list value
      end

      categories

    end
  end
end





