class Podio::AccountProvider < ActivePodio::Base
  property :name, :string
  property :connect_link, :string
  property :humanized_name, :string
  property :capabilities, :array
  property :capability_names, :hash

  class << self

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url("/linked_account/provider/", options)
      }.body
    end

  end
end
