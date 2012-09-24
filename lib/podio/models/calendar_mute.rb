# @see https://developers.podio.com/doc/calendar
class Podio::CalendarMute < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :title, :string
  property :data, :hash
  property :item, :boolean
  property :status, :boolean
  property :task, :boolean

  class << self

    # @see https://developers.podio.com/doc/calendar/get-mutes-in-global-calendar-62730
    def find_all
      list Podio.connection.get('/calendar/mute/').body
    end

    # @see https://developers.podio.com/doc/calendar/mute-objects-from-global-calendar-79418
    def create(scope_type, scope_id, object_type = nil)
      path = "/calendar/mute/#{scope_type}/#{scope_id}/"
      path += "#{object_type}/" unless object_type.nil?
      Podio.connection.post(path).status
    end

    # @see https://developers.podio.com/doc/calendar/unmute-objects-from-the-global-calendar-79420
    def delete(scope_type, scope_id, object_type = nil)
      path = "/calendar/mute/#{scope_type}/#{scope_id}/"
      path += "#{object_type}/" unless object_type.nil?
      Podio.connection.delete(path).status
    end
  end
end
