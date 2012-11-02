# @see https://developers.podio.com/doc/reference
class Podio::Reference < ActivePodio::Base

  property :type, :string
  property :id, :integer
  property :title, :string
  property :link, :string
  property :data, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  class << self
    # @see https://developers.podio.com/doc/reference/get-reference-10661022
    def find(ref_type, ref_id, options = {})
      member Podio.connection.get { |req|
        req.url("/reference/#{ref_type}/#{ref_id}", options)
      }.body
    end

    # @see https://developers.podio.com/doc/reference/search-references-13312595
    def search(target, query, limit, target_params = nil)
      response = Podio.connection.post do |req|
        req.url "/reference/search"
        req.body = {
          :target => target,
          :text => query,
          :limit => limit
        }
        req.body[:target_params] = target_params if target_params.present?
      end
      response.body
    end

    # @see https://developers.podio.com/doc/reference/get-users-with-access-to-object-16681010
    def find_users_with_access(ref_type, ref_id, options = {})
      self.klass_from_string('Contact').list Podio.connection.get { |req|
        req.url("/reference/#{ref_type}/#{ref_id}/accessible_by/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/reference/count-user-profiles-with-access-to-object-19190550
    def count_users_with_access(ref_type, ref_id)
      Podio.connection.get("/reference/#{ref_type}/#{ref_id}/accessible_by/count").body['count']
    end
  end
end
