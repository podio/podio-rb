class Podio::UserStatus < ActivePodio::Base
  property :user, :hash
  property :profile, :hash
  property :properties, :hash
  property :inbox_new, :integer
  property :calendar_code, :string
  property :task_mail, :string
  property :mailbox, :string

  has_one :user, :class => 'User'
  has_one :contact, :class => 'Contact', :property => :profile
  
  class << self
    def current
      member Podio.connection.get("/user/status").body
    end
    def find_for_space(space_id)
      Podio.connection.get("/user/status/1ux/space/#{space_id}").body
    end
  end
end
