class Podio::Task < ActivePodio::Base
  include ActivePodio::Updatable

  property :task_id, :integer
  property :status, :string
  property :group, :string
  property :text, :string
  property :description, :string
  property :private, :boolean
  property :due_date, :date
  property :responsible, :hash
  property :space_id, :integer
  property :link, :string
  property :created_on, :datetime
  property :completed_on, :datetime
  property :file_ids, :array # when inputting tasks
  property :label_ids, :array # when inputting tasks
  property :labels, :array # when outputting tasks

  # old references
  property :ref_type, :string
  property :ref_id, :integer
  property :ref_title, :string
  property :ref_link, :string

  # new reference
  property :ref, :hash

  has_one :created_by, :class => Podio::User
  has_one :completed_by, :class => Podio::User
  has_one :created_via, :class => Podio::Via
  has_one :deleted_via, :class => Podio::Via
  has_one :completed_via, :class => Podio::Via
  has_one :assignee, :class => Podio::User, :property => :responsible
  has_many :label_list, :class => Podio::TaskLabel, :property => :labels 
  has_many :files, :class => Podio::FileAttachment
  has_many :comments, :class => Podio::Comment

  alias_method :id, :task_id
  
  def create
    compacted_attributes = remove_nil_values(self.attributes)
    if(self.ref_type.present? && self.ref_id.present?)
      self.task_id = self.class.create_with_ref(self.ref_type, self.ref_id, compacted_attributes)
    else
      self.task_id = self.class.create(compacted_attributes)
    end
  end
  
  def destroy
    self.class.delete(self.id)
  end

  def update_reference(ref_type, ref_id)
    self.class.update_reference(self.id, ref_type, ref_id)
  end

  def update_labels(label_ids)
    self.class.update_labels(self.id, label_ids)
  end

  def complete
    self.class.complete(self.id)
  end

  def uncomplete
    self.class.incomplete(self.id)
  end

  def rank(previous_task, next_task)
    self.class.rank(self.id, previous_task && previous_task.to_i, next_task && next_task.to_i)
  end

  handle_api_errors_for :create, :destroy, :complete, :uncomplete, :update_reference # Call must be made after the methods to handle have been defined

  class << self
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/task/"
        req.body = attributes
      end

      response.body['task_id']
    end

    def create_with_ref(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/task/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      response.body['task_id']
    end

    def update_description(id, description)
      Podio.connection.put("/task/#{id}/description", {:description => description}).status
    end

    def update_text(id, text)
      Podio.connection.put("/task/#{id}/text", {:text => text}).status
    end

    def update_private(id, private_flag)
      Podio.connection.put("/task/#{id}/private", {:private => private_flag}).status
    end

    def update_due_date(id, due_date)
      Podio.connection.put("/task/#{id}/due_date", {:due_date => due_date}).status
    end

    def update_assignee(id, user_id)
      Podio.connection.post("/task/#{id}/assign", {:responsible => user_id}).status
    end

    def update_reference(id, ref_type, ref_id)
      Podio.connection.put("/task/#{id}/ref", {:ref_type => ref_type, :ref_id => ref_id}).status
    end
    
    def update_labels(id, label_ids)
      Podio.connection.put("/task/#{id}/label/", label_ids).status
    end

    def delete(id)
      Podio.connection.delete("/task/#{id}").status
    end

    def complete(id)
      Podio.connection.post("/task/#{id}/complete").body
    end

    def incomplete(id)
      Podio.connection.post("/task/#{id}/incomplete").body
    end

    def rank(id, before_task_id, after_task_id)
      Podio.connection.post("/task/#{id}/rank", {:before => before_task_id, :after => after_task_id}).body
    end

    def find(id)
      member Podio.connection.get("/task/#{id}").body
    end

    def find_for_reference(ref_type, ref_id)
      list Podio.connection.get("/task/#{ref_type}/#{ref_id}/").body
    end

    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/task/', options)
      }.body
    end
  end
end
