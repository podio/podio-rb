# TODO: Add documention links for this area once the docs has been made public
class Podio::Grant < ActivePodio::Base

  property :ref_type, :string
  property :ref_id, :integer
  property :people, :hash
  property :action, :string
  property :message, :string

  has_one :created_by, :class => 'ByLine'
  has_one :user, :class => 'Contact'

  def save
    self.class.create(self.ref_type, self.ref_id, self.attributes)
  end

  handle_api_errors_for :save

  class << self
    def create(ref_type, ref_id, attributes={})
      response = Podio.connection.post do |req|
        req.url "/grant/#{ref_type}/#{ref_id}"
        req.body = attributes
      end

      response.body
    end

    def find_own(ref_type, ref_id)
      response = Podio.connection.get("/grant/#{ref_type}/#{ref_id}/own")
      if response.status == 200
        member response.body
      else
        nil
      end
    end

    def find_all(ref_type, ref_id)
      list Podio.connection.get("grant/#{ref_type}/#{ref_id}/").body
    end

    def delete(ref_type, ref_id, user_id)
      Podio.connection.delete("grant/#{ref_type}/#{ref_id}/#{user_id}").body
    end

    def count_by_reference(ref_type, ref_id)
      Podio.connection.get("/grant/#{ref_type}/#{ref_id}/count").body['count']
    end
  end
end
