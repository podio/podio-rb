require 'faraday'
require 'active_support/core_ext'

require 'podio/error'
require 'podio/middleware/json_request'
#require 'podio/middleware/date_conversion'
require 'podio/middleware/logger'
require 'podio/middleware/oauth2'
require 'podio/middleware/json_response'
require 'podio/middleware/error_response'
require 'podio/middleware/response_recorder'

require 'podio/active_podio/base'
require 'podio/active_podio/updatable'

module Podio
  class << self
    def setup(options={})
      Podio.client = Podio::Client.new(options)
    end

    def client
      Thread.current[:podio_client]
    end

    def client=(new_client)
      Thread.current[:podio_client] = new_client
    end

    def with_client
      old_client = Podio.client.try(:dup)
      yield
    ensure
      Podio.client = old_client
    end

    def connection
      client ? client.connection : nil
    end
  end

  class StdoutLogger
    def initialize(debug)
      @debug = debug
    end

    def log(env)
      begin
        puts "\n==> #{env[:method].to_s.upcase} #{env[:url]} \n\n" if @debug
        yield
      ensure
        puts "\n== (#{env[:status]}) ==> #{env[:body]}\n\n" if @debug
      end
    end
  end

  class OAuthToken < Struct.new(:access_token, :refresh_token, :expires_at, :reference, :refreshed)
    def initialize(params = {})
      self.access_token  = params['access_token']
      self.refresh_token = params['refresh_token']
      self.reference     = params['ref']
      self.expires_at    = Time.now + params['expires_in'] if params['expires_in']
    end
  end

  autoload :Client,                   'podio/client'
  autoload :ResponseWrapper,          'podio/response_wrapper'
                                      
  autoload :Action,                   'podio/models/action'
  autoload :ActivationStatus,         'podio/models/activation_status'
  autoload :Activity,                 'podio/models/activity'
  autoload :AppStoreShare,            'podio/models/app_store_share'
  autoload :Application,              'podio/models/application'
  autoload :ApplicationEmail,         'podio/models/application_email'
  autoload :ApplicationField,         'podio/models/application_field'
  autoload :Bulletin,                 'podio/models/bulletin'
  autoload :ByLine,                   'podio/models/by_line'
  autoload :Calendar,                 'podio/models/calendar'
  autoload :CalendarMute,             'podio/models/calendar_mute'
  autoload :Category,                 'podio/models/category'
  autoload :Comment,                  'podio/models/comment'
  autoload :Connection,               'podio/models/connection'
  autoload :Contact,                  'podio/models/contact'
  autoload :Contract,                 'podio/models/contract'
  autoload :ContractAccounting,       'podio/models/contract_accounting'
  autoload :ContractPrice,            'podio/models/contract_price'
  autoload :Conversation,             'podio/models/conversation'
  autoload :ConversationMessage,      'podio/models/conversation_message'
  autoload :ConversationParticipant,  'podio/models/conversation_participant'
  autoload :EmailSubscriptionSetting, 'podio/models/email_subscription_setting'
  autoload :Embed,                    'podio/models/embed'
  autoload :FileAttachment,           'podio/models/file_attachment'
  autoload :Filter,                   'podio/models/filter'
  autoload :Form,                     'podio/models/form'
  autoload :Hook,                     'podio/models/hook'
  autoload :Importer,                 'podio/models/importer'
  autoload :Integration,              'podio/models/integration'
  autoload :Item,                     'podio/models/item'
  autoload :ItemDiff,                 'podio/models/item_diff'
  autoload :ItemField,                'podio/models/item_field'
  autoload :ItemRevision,             'podio/models/item_revision'
  autoload :Meeting,                  'podio/models/meeting'
  autoload :MeetingParticipant,       'podio/models/meeting_participiant'
  autoload :News,                     'podio/models/news'
  autoload :Notification,             'podio/models/notification'
  autoload :NotificationGroup,        'podio/models/notification_group'
  autoload :OAuth,                    'podio/models/o_auth'
  autoload :OAuthClient,              'podio/models/o_auth_client'
  autoload :Organization,             'podio/models/organization'
  autoload :OrganizationContact,      'podio/models/organization_contact'
  autoload :OrganizationMember,       'podio/models/organization_member'
  autoload :OrganizationProfile,      'podio/models/organization_profile'
  autoload :Profile,                  'podio/models/profile'
  autoload :Question,                 'podio/models/question'
  autoload :QuestionAnswer,           'podio/models/question_answer'
  autoload :QuestionOption,           'podio/models/question_option'
  autoload :Rating,                   'podio/models/rating'
  autoload :Recurrence,               'podio/models/recurrence'
  autoload :Reminder,                 'podio/models/reminder'
  autoload :Search,                   'podio/models/search'
  autoload :Space,                    'podio/models/space'
  autoload :SpaceContact,             'podio/models/space_contact'
  autoload :SpaceInvitation,          'podio/models/space_invitation'
  autoload :SpaceMember,              'podio/models/space_member'
  autoload :Status,                   'podio/models/status'
  autoload :StreamMute,               'podio/models/stream_mute'
  autoload :StreamObject,             'podio/models/stream_object'
  autoload :Subscription,             'podio/models/subscription'
  autoload :Tag,                      'podio/models/tag'
  autoload :TagSearch,                'podio/models/tag_search'
  autoload :Task,                     'podio/models/task'
  autoload :TaskLabel,                'podio/models/task_label'
  autoload :User,                     'podio/models/user'
  autoload :UserMail,                 'podio/models/user_mail'
  autoload :UserStatus,               'podio/models/user_status'
  autoload :Via,                      'podio/models/via'
  autoload :Widget,                   'podio/models/widget'

end
