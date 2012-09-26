class Podio::ActivationStatus < ActivePodio::Base
  property :user_id, :integer
  property :status, :string
  property :mail, :string
  property :space_count, :integer

  class << self
    def find(activation_code)
      member Podio.client.trusted_connection.get("/user/status/activation?activation_code=#{activation_code}").body
    end
  end
end
