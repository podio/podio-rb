# @see https://developers.podio.com/doc/hooks
class Podio::Hook < ActivePodio::Base
  property :hook_id, :integer
  property :status, :string
  property :type, :string
  property :url, :string

  alias_method :id, :hook_id

  attr_accessor :hookable_type, :hookable_id

  # @see https://developers.podio.com/doc/hooks/create-hook-215056
  def create
    self.hook_id = self.class.create(self.hookable_type, self.hookable_id, attributes)
  end

  class << self
    # @see https://developers.podio.com/doc/hooks/create-hook-215056
    def create(hookable_type, hookable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/hook/#{hookable_type}/#{hookable_id}/"
        req.body = {:url => attributes[:url], :type => attributes[:type]}
      end

      response.body['hook_id']
    end

    # @see https://developers.podio.com/doc/hooks/request-hook-verification-215232
    def verify(hook_id)
      Podio.connection.post do |req|
        req.url "/hook/#{hook_id}/verify/request"
      end
    end

    # @see https://developers.podio.com/doc/hooks/validate-hook-verification-215241
    def validate(hook_id, code)
      Podio.connection.post do |req|
        req.url "/hook/#{hook_id}/verify/validate"
        req.body = {:code => code}
      end
    end

    # @see https://developers.podio.com/doc/hooks/delete-hook-215291
    def delete(hook_id)
      Podio.connection.delete do |req|
        req.url "/hook/#{hook_id}"
      end
    end

    # @see https://developers.podio.com/doc/hooks/get-hooks-215285
    def find_all_for(hookable_type, hookable_id)
      list Podio.connection.get("/hook/#{hookable_type}/#{hookable_id}/").body
    end
  end
end
