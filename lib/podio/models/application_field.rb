# @see https://developers.podio.com/doc/applications
class Podio::ApplicationField < ActivePodio::Base
  property :field_id, :integer
  property :type, :string
  property :external_id, :string
  property :config, :hash
  property :status, :string
  property :label, :string

  alias_method :id, :field_id
  delegate_to_hash :config, :description, :delta, :settings, :required?, :visible?
  delegate_to_hash :settings, :allowed_values, :referenceable_types, :allowed_currencies, :allowed_mimetypes, :valid_types, :options, :multiple

  class << self
    # @see https://developers.podio.com/doc/applications/get-app-field-22353
    def find(app_id, field_id)
      member Podio.connection.get("/app/#{app_id}/field/#{field_id}").body
    end

  end
end
