module Podio
  module OAuth
    include Podio::ResponseWrapper
    extend self

    def authorize(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/authorize"
        req.body = attributes
      end

      response.body
    end

    def get_info(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/info"
        req.body = attributes
      end

      response.body
    end

    def get_access_token(attributes)
      response = Podio.connection.post do |req|
        req.url "/oauth/token"
        req.body = attributes
      end

      response.body
    end

    module OAuthClient
      include Podio::ResponseWrapper
      extend self

      def create(attributes)
        response = Podio.connection.post do |req|
          req.url "/oauth/client/"
          req.body = attributes
        end

        response.body['auth_client_id']
      end

      def create_admin(user_id, attributes)
        response = Podio.connection.post do |req|
          req.url "/oauth/client/user/#{user_id}/"
          req.body = attributes
        end

        response.status
      end

      def update(id, attributes)
        response = Podio.connection.put do |req|
          req.url "/oauth/client/#{id}"
          req.body = attributes
        end

        response.status
      end

      def update_admin(id, attributes)
        response = Podio.connection.put do |req|
          req.url "/oauth/client/#{id}/admin"
          req.body = attributes
        end

        response.status
      end

      def delete(id)``
        response = Podio.connection.delete("/oauth/client/#{id}")

        response.status
      end

      def delete_grant(id)
         response = Podio.connection.delete("/oauth/grant/client/#{id}")

         response.status
       end

      def find_granted_clients()
        list Podio.connection.get("oauth/grant/client/").body
      end

      def find_all_for_current_user()
        list Podio.connection.get("oauth/client/").body
      end

      def find_all_for_user(user_id)
        list Podio.connection.get("oauth/client/user/#{user_id}/").body
      end

      def find(client_id)
        member Podio.connection.get("oauth/client/#{client_id}").body
      end
    end
  end
end