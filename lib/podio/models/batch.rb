# @see https://developers.podio.com/doc/batch
class Podio::Batch < ActivePodio::Base
  property :batch_id, :integer
  property :name, :string
  property :plugin, :string
  property :status, :string
  property :completed, :integer
  property :skipped, :integer
  property :failed, :integer
  property :created_on, :datetime
  property :started_on, :datetime
  property :ended_on, :datetime

  has_one :file, :class => 'FileAttachment'
  has_one :app, :class => 'Application'
  has_one :space, :class => 'Space'

  alias_method :id, :batch_id

  class << self
    # @see https://developers.podio.com/doc/batch/get-batch-6144225
    def find(id)
      member Podio.connection.get("/batch/#{id}").body
    end

    # @see https://developers.podio.com/doc/batch/get-batches-6078877
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url("/batch/", options)
      }.body
    end

    # @see https://developers.podio.com/doc/batch/get-running-batches-15856178
    def find_running(ref_type, ref_id, plugin)
      list Podio.connection.get("/batch/#{ref_type}/#{ref_id}/#{plugin}/running/").body
    end
  end

end
