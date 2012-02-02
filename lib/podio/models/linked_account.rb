class Podio::LinkedAccount < ActivePodio::Base
  property :linked_account_id, :integer
  property :label, :string
  property :provider, :string


  class << self

    def find_all(provider, scope = nil)
      options = { :provider => provider }
      options[:scope] = scope if scope.present?
      list Podio.connection.get { |req|
        req.url("/linked_account/", options)
      }.body
    end

  end
end
