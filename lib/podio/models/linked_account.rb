class Podio::LinkedAccount < ActivePodio::Base
  property :linked_account_id, :integer
  property :label, :string
  property :provider, :string


  class << self

    def find_all(provider, scope)
      list Podio.connection.get("/linked_account/?provider=#{provider}&scope=#{scope}").body
    end

  end
end