class Podio::LinkedAccount < ActivePodio::Base
  property :linked_account_id, :integer
  property :label, :string
  property :provider, :string


  class << self

    def find_all(provider, capability = nil)
      options = { :provider => provider }
      options[:capability] = capability if capability.present?
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

  end
end
