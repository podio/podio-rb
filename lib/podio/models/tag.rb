# @see https://developers.podio.com/doc/tags
class Podio::Tag < ActivePodio::Base
  property :count, :integer
  property :text, :string

  class << self
    # @see https://developers.podio.com/doc/tags/create-tags-22464
    def create(tagable_type, tagable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/tag/#{tagable_type}/#{tagable_id}/"
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/tags/update-tags-39859
    def update(tagable_type, tagable_id, attributes)
      response = Podio.connection.put do |req|
        req.url "/tag/#{tagable_type}/#{tagable_id}/"
        req.body = attributes
      end

      response.body
    end

    # @see https://developers.podio.com/doc/tags/get-tags-on-app-22467
    def find_by_app(app_id, limit, text)
      text = CGI.escape(text) if text
      list Podio.connection.get("/tag/app/#{app_id}/?limit=#{limit}&text=#{text}").body
    end

    # @see https://developers.podio.com/doc/tags/get-tags-on-app-top-68485
    def find_top_by_app(app_id, limit, text)
      text = CGI.escape(text) if text
      Podio.connection.get("/tag/app/#{app_id}/top/?limit=#{limit}&text=#{text}").body
    end

    # @see https://developers.podio.com/doc/tags/get-tags-on-space-22466
    def find_by_space(space_id, limit, text)
      text = CGI.escape(text) if text
      list Podio.connection.get("/tag/space/#{space_id}/?limit=#{limit}&text=#{text}").body
    end

    # @see https://developers.podio.com/doc/tags/get-tags-on-organization-48473
    def find_by_org(org_id, limit, text)
      text = CGI.escape(text) if text
      list Podio.connection.get("/tag/org/#{org_id}/?limit=#{limit}&text=#{text}").body
    end

    # @see https://developers.podio.com/doc/tags/get-objects-on-app-with-tag-22469
    def find_for_app(app_id, attributes)
      list Podio.connection.get("/tag/app/#{app_id}/search/", attributes).body
    end

    # @see https://developers.podio.com/doc/tags/get-objects-on-space-with-tag-22468
    def find_for_space(space_id, attributes)
      list Podio.connection.get("/tag/space/#{space_id}/search/", attributes).body
    end

    # @see https://developers.podio.com/doc/tags/get-objects-on-organization-with-tag-48478
    def find_for_org(org_id, attributes)
      list Podio.connection.get("/tag/org/#{org_id}/search/", attributes).body
    end

    # @see https://developers.podio.com/doc/tags/remove-tag-22465
    def delete(tagable_type, tagable_id, attributes)
      response = Podio.connection.delete do |req|
        req.url "/tag/#{tagable_type}/#{tagable_id}/"
        req.body = attributes
      end

      response.body
    end
  end
end
