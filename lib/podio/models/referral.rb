class Podio::Referral < ActivePodio::Base
  property :code, :string
  property :status, :string

  alias_method :id, :code

  class << self
    def find_referral_contact(code)
      Contact.member Podio.connection.get("/referral/info/#{code}").body
    end

    def find_referred_users
      Contact.list Podio.connection.get("/referral/user/").body
    end

    def update_teaser_status(status)
      response = Podio.connection.put do |req|
        req.url "/referral/status"
        req.body = { :status => status }
      end
      response.status
    end
  end

end
