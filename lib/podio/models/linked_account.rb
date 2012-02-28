class Podio::LinkedAccount < ActivePodio::Base
  property :linked_account_id, :integer
  property :label, :string
  property :provider, :string

  alias_method :id, :linked_account_id

  class << self

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url("/linked_account/", options)
      }.body
    end

    def create(attributes)
      response = Podio.connection.post do |req|
        req.url '/linked_account/'
        req.body = attributes
      end

      member response.body
    end

    def delete(id)
      Podio.connection.delete("/linked_account/#{id}").status
    end

  end
end
