class Podio::ActivationStatus < ActivePodio::Base
  property :space_count, :integer
  
  class << self
    def find(activation_code)
      member Podio.connection.get("/user/status/activation?activation_code=#{activation_code}").body
    end
  end
end
