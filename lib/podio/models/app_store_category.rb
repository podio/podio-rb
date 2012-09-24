# @see https://developers.podio.com/doc/app-store
class Podio::AppStoreCategory < ActivePodio::Base
  property :category_id, :integer
  property :name, :string
  property :type, :string

  alias_method :id, :category_id

  class << self

    # @see https://developers.podio.com/doc/app-market/get-shares-by-category-22498
    def find(category_id)
      member Podio.connection.get("/app_store/category/#{category_id}").body
    end

    # @see https://developers.podio.com/doc/app-market/get-categories-37009
    def find_all
      categories = Podio.connection.get("/app_store/category/").body

      categories.each do | key, value |
        categories[key] = list value
      end

      categories

    end
  end
end
