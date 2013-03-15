# @see https://developers.podio.com/doc/users
class Podio::UserStatus < ActivePodio::Base
  property :user, :hash
  property :profile, :hash
  property :properties, :hash
  property :inbox_new, :integer
  property :calendar_code, :string
  property :task_mail, :string
  property :mailbox, :string
  property :message_unread_count, :integer
  property :flags, :array
  property :betas, :array
  property :push, :hash
  property :presence, :hash

  has_one :user, :class => 'User'
  has_one :contact, :class => 'Contact', :property => :profile
  has_one :referral, :class => 'Referral'

  class << self
    # @see https://developers.podio.com/doc/users/get-user-status-22480
    def current
      member Podio.connection.get("/user/status").body
    end

    def find_first_ux
      Podio.connection.get("/user/status/1ux").body
    end

    def find_for_space(space_id)
      Podio.connection.get("/user/status/1ux/space/#{space_id}").body
    end
  end
end
