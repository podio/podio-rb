class Podio::AppStoreCategory < ActivePodio::Base
  property :category_id, :integer
  property :name, :string

  alias_method :id, :category_id

  class << self

    def find_all
      Podio.connection.get("/app_store/category/").body
    end

  end
end





