# @see https://developers.podio.com/doc/stream
class Podio::StreamMute < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :title, :string
  property :data, :hash

  class << self
    # @see https://developers.podio.com/doc/stream/get-mutes-in-global-stream-62742
    def find_all
      list Podio.connection.get('/stream/mute/v2/').body
    end

    # @see https://developers.podio.com/doc/stream/mute-object-from-global-stream-79424
    def create(scope_type, scope_id)
      path = "/stream/mute/#{scope_type}/#{scope_id}"
      Podio.connection.post(path).status
    end

    # @see https://developers.podio.com/doc/stream/unmute-objects-from-the-global-stream-79426
    def delete(scope_type, scope_id)
      path = "/stream/mute/#{scope_type}/#{scope_id}"
      Podio.connection.delete(path).status
    end
  end
end
