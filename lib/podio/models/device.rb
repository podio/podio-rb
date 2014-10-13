# @see https://developers.podio.com/doc/actions
class Podio::Device < ActivePodio::Base
  property :app, :string
  property :type, :string
  property :token, :string

  class << self
    def find_all_for_user(user_id)
      list Podio.connection.get("/mobile/user/#{user_id}").body
    end
    
    def send_test(user_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/mobile/user/#{user_id}/test"
        req.body = attributes
      end

      response.body['pushed']
    end
  end

end
