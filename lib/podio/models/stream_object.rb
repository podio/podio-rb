class Podio::StreamObject < ActivePodio::Base
  property :id, :integer
  property :type, :string
  property :last_update_on, :datetime
  property :title, :string
  property :link, :string
  property :rights, :array
  property :data, :hash
  property :comments_allowed, :boolean
  property :user_ratings, :hash
  property :created_on, :datetime

  has_one :created_by, :class => 'ByLine'
  has_one :created_via, :class => 'Via'
  has_one :app, :class => 'Application'
  has_one :space, :class => 'Space'
  has_one :org, :class => 'Organization'
  
  has_many :comments, :class => 'Comment'
  has_many :files, :class => 'FileAttachment'
  has_many :activity, :class => 'Activity'

  class << self
    def find_all_by_user_id(user_id, options={})
      list Podio.connection.get { |req|
        req.url("/stream/user/#{user_id}/", options)
      }.body      
    end
    
    def find_by_ref(ref_type, ref_id)
      member Podio.connection.get("/stream/#{ref_type}/#{ref_id}/v2").body
    end
  end
end
