# @see https://developers.podio.com/doc/actions
class Podio::Action < ActivePodio::Base
  property :action_id, :integer
  property :type, :string
  property :data, :hash
  property :text, :string
  property :push, :hash
  property :presence, :hash
  property :pinned, :boolean
  property :created_on, :datetime
  property :subscribed, :boolean
  property :is_liked, :boolean
  property :like_count, :integer
  property :subscribed_count, :integer
  property :push, :hash
  property :presence, :hash
  property :rights, :array

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_many :comments, :class => 'Comment'

  alias_method :id, :action_id

  class << self
    # @see https://developers.podio.com/doc/actions/get-action-1701120
    def find(id)
      member Podio.connection.get("/action/#{id}").body
    end
  end

end
