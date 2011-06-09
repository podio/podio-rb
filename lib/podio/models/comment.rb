class Podio::Comment < ActivePodio::Base
  property :comment_id, :integer
  property :value, :string
  property :external_id, :integer
  property :space_id, :integer
  property :created_on, :datetime
  property :files, :array # when outputting comments
  property :file_ids, :array # when inputting comments
  
  has_one :created_by, :class => Podio::ByLine
  has_one :created_via, :class => Podio::Via
  has_many :files, :class => Podio::FileAttachment

  alias_method :id, :comment_id
  attr_accessor :commentable_type, :commentable_id

  def create
    self.comment_id = Comment.create(commentable_type, commentable_id, attributes)
  end
  
  class << self
    def create(commentable_type, commentable_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/comment/#{commentable_type}/#{commentable_id}"
        req.body = attributes
      end

      response.body['comment_id']
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/comment/#{id}"
        req.body = attributes
      end

      response.status
    end

    def delete(id)
      Podio.connection.delete("/comment/#{id}").status
    end

    def find(id)
      member Podio.connection.get("/comment/#{id}").body
    end

    def find_all_for(commentable_type, commentable_id)
      list Podio.connection.get("/comment/#{commentable_type}/#{commentable_id}").body
    end

    def find_recent_for_share
      #Internal
      list Podio.connection.get("/comment/share/").body
    end
    
  end
end
