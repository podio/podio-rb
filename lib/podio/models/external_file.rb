# @see https://developers.podio.com/doc/files
class Podio::ExternalFile < ActivePodio::Base
  property :external_file_id, :string
  property :name, :string
  property :mimetype, :string

  property :created_on, :datetime
  property :updated_on, :datetime

  alias_method :id, :external_file_id


  class << self

    def find_all_for_linked_account(linked_account_id, options={})
      list Podio.connection.get { |req|
        req.url("/file/linked_account/#{linked_account_id}/", options)
      }.body
    end


    def create_from_external_file_id(linked_account_id, external_file_id, preserve_permissions=false)
      response = Podio.client.connection.post do |req|
        req.url "/file/linked_account/#{linked_account_id}/"
        req.body = {
            :external_file_id     => external_file_id,
            :preserve_permissions => preserve_permissions
        }
      end

      member response.body
    end

  end
end
