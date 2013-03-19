# @see https://developers.podio.com/doc/status
class Podio::Status < ActivePodio::Base
  property :status_id, :integer
  property :value, :string
  property :rich_value, :string
  property :link, :string
  property :created_on, :datetime
  property :alerts, :array
  property :ratings, :hash
  property :subscribed, :boolean
  property :pinned, :boolean
  property :user_ratings, :hash
  property :rights, :array
  property :is_liked, :boolean
  property :like_count, :integer
  property :subscribed_count, :integer
  property :push, :hash
  property :presence, :hash

  # Properties for create
  property :file_ids, :array
  property :embed_id, :integer
  property :embed_file_id, :integer

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_one :embed, :class => 'Embed'
  has_one :embed_file, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_many :conversations, :class => 'Conversation'
  has_many :tasks, :class => 'Task'
  has_many :shares, :class => 'AppStoreShare'
  has_many :files, :class => 'FileAttachment'
  has_many :questions, :class => 'Question'

  alias_method :id, :status_id

  # @see https://developers.podio.com/doc/status/delete-a-status-message-22339
  def destroy
    Status.delete(self.id)
  end

  class << self
    # @see https://developers.podio.com/doc/status/get-status-message-22337
    def find(id)
      member Podio.connection.get("/status/#{id}").body
    end

    # @see https://developers.podio.com/doc/status/add-new-status-message-22336
    def create(space_id, attributes=[])
      response = Podio.connection.post do |req|
        req.url "/status/space/#{space_id}/"
        req.body = attributes
      end

      response.body['status_id']
    end

    # @see https://developers.podio.com/doc/status/delete-a-status-message-22339
    def delete(id)
      Podio.connection.delete("/status/#{id}").body
    end
  end

end
