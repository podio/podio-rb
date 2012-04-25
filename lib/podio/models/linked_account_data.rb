class Podio::LinkedAccountData < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :info, :string
  property :url, :string
end
