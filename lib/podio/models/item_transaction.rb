class Podio::ItemTransaction < ActivePodio::Base
  property :item_transaction_id, :integer
  property :state, :string
  property :reason, :string
  property :amount, :integer

  property :text, :string

  property :created_on, :datetime

  property :ratings, :hash
  property :created_on, :datetime
  property :rights, :array
  property :is_liked, :boolean
  property :like_count, :integer

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'

  has_many :comments, :class => 'Comment'
  has_many :tasks, :class => 'Task'

  alias_method :id, :item_transaction_id

  class << self

    def find(id)
      member Podio.connection.get { |req|
        req.url("/item_accounting/transaction/#{id}")
      }.body
    end

  end
end
