class Podio::Status < ActivePodio::Base
  property :status_id, :integer
  property :value, :string
  property :rich_value, :string
  property :link, :string
  property :created_on, :datetime
  property :alerts, :array
  property :ratings, :hash
  property :subscribed, :boolean
  property :user_ratings, :hash

  # Properties for create
  property :file_ids, :array
  property :embed_id, :integer
  property :embed_file_id, :integer

  has_one :created_by, :class => 'Contact'
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

  def destroy
    Status.delete(self.id)
  end
  
  class << self
    def find(id)
      member Podio.connection.get("/status/#{id}").body
    end

    def create(space_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/status/space/#{space_id}/"
        req.body = attributes
      end

      response.body['status_id']
    end
    
    def delete(id)
      Podio.connection.delete("/status/#{id}").body
    end
  end
  
end