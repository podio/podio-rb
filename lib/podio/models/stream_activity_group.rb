# @see https://developers.podio.com/doc/stream
class Podio::StreamActivityGroup < ActivePodio::Base

  property :group_id, :integer
  property :kind, :string
  property :type, :string
  property :created_on, :datetime
  property :activities, :array

  has_one :data_ref, :class => 'Reference'
  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  has_many :authors, :class => 'ByLine'

  alias_method :id, :group_id

  class << self

    def find_by_ref(ref_type, ref_id, options = {})
      list Podio.connection.get { |req|
        req.url("/stream/#{ref_type}/#{ref_id}/activity_group", options)
      }.body
    end

    def find_for_data_ref(ref_type, ref_id, data_ref_type, data_ref_id)
      member Podio.connection.get { |req|
        req.url("/stream/#{ref_type}/#{ref_id}/activity_group/#{data_ref_type}/#{data_ref_id}")
      }.body
    end

  end

end
