class Podio::Meeting < ActivePodio::Base
  include ActivePodio::Updatable, HasReference

  property :meeting_id, :integer
  property :title, :string
  property :starts_on, :datetime, :convert_incoming_local_datetime_to_utc => true
  property :ends_on, :datetime, :convert_incoming_local_datetime_to_utc => true
  property :participant_ids, :array
  property :is_remote, :boolean
  property :status, :string
  property :location, :string
  property :agenda, :string
  property :notes, :string
  property :transcript, :string
  property :external_id, :string
  property :external_url, :string
  property :external_phone, :string
  property :external_password, :string
  property :external_recording_url, :string
  property :created_on, :datetime
  property :deleted_on, :datetime
  property :link, :string
  property :ref, :hash
  
  # For creation only
  property :ref_id, :integer
  property :ref_type, :string

  has_one :created_by, :class => 'User'
  has_one :created_via, :class => 'Via'
  has_one :deleted_by, :class => 'User'
  has_one :deleted_via, :class => 'Via'
  has_many :participants, :class => 'MeetingParticipant'

  alias_method :id, :meeting_id
  
  def create
    compacted_attributes = remove_nil_values(self.attributes)
    created_model = if(self.ref_type.present? && self.ref_id.present?)
      self.class.create_with_ref(self.ref_type, self.ref_id, compacted_attributes)
    else
      self.class.create(compacted_attributes)
    end
    
    self.attributes = created_model.attributes
  end

  def update
    compacted_attributes = remove_nil_values(self.attributes)
    updated_model = self.class.update(self.id, compacted_attributes)
    self.attributes = updated_model.attributes
  end
  
  def destroy
    self.class.delete(self.id)
  end

  def start
    self.class.start(self.id)
  end

  def stop
    self.class.stop(self.id)
  end

  handle_api_errors_for :create, :destroy, :start, :stop # Call must be made after the methods to handle have been defined

  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/meeting/"
        req.body = attributes
      end

      member response.body
    end

    def create_with_ref(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/meeting/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      member response.body
    end

    def update(id, attributes)
      response = Podio.connection.put do |req|
        req.url "/meeting/#{id}"
        req.body = attributes
      end

      member response.body
    end

    def delete(id)
      Podio.connection.delete("/meeting/#{id}").status
    end

    def start(id)
      Podio.connection.post("/meeting/#{id}/start").body
    end

    def stop(id)
      Podio.connection.post("/meeting/#{id}/stop").body
    end

    def find(id)
      member Podio.connection.get("/meeting/#{id}").body
    end

    def find_for_reference(ref_type, ref_id)
      list Podio.connection.get("/meeting/#{ref_type}/#{ref_id}/").body
    end

    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/meeting/', options)
      }.body
    end
  end
end
