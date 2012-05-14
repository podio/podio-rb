class Podio::CalendarEvent < ActivePodio::Base
  property :type, :string
  property :id, :integer
  property :group, :string
  property :title, :string
  property :description, :string
  property :location, :string
  property :start, :datetime, :convert_timezone => false
  property :end, :datetime, :convert_timezone => false
  property :link, :string

  class << self

    def find_all(options = {})
      list Podio.connection.get { |req|
        req.url('/calendar/', options)
      }.body
    end

    def find_all_for_space(space_id, options={})
      list Podio.connection.get { |req|
        req.url("/calendar/space/#{space_id}/", options)
      }.body
    end

    def find_summary
      response = Podio.connection.get("/calendar/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    def find_summary_for_space(space_id)
      response = Podio.connection.get("/calendar/space/#{space_id}/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    def find_summary_for_org(org_id)
      response = Podio.connection.get("/calendar/org/#{org_id}/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

    def find_personal_summary
      response = Podio.connection.get("/calendar/personal/summary").body
      response['today']['events'] = list(response['today']['events'])
      response['upcoming']['events'] = list(response['upcoming']['events'])
      response
    end

  end
end
