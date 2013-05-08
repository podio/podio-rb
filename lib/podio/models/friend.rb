
class Podio::Friend < ActivePodio::Base

  class << self

    def delete(user_ids)
      Podio.connection.delete("/friend/#{user_ids}").status
    end

  end

end
