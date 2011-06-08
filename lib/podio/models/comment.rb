class Podio::Comment < ActivePodio::Base
  property :comment_id, :integer
  property :value, :string
  property :external_id, :integer
  property :space_id, :integer
  property :created_on, :datetime
  property :files, :array # when outputting comments
  property :file_ids, :array # when inputting comments
  
  has_one :created_by, :class => ByLine
  has_one :created_via, :class => Via
  has_many :files, :class => FileAttachment

  alias_method :id, :comment_id
  attr_accessor :commentable_type, :commentable_id

  def create
    self.comment_id = Comment.create(commentable_type, commentable_id, attributes)
  end
end
