class Podio::Task < ActivePodio::Base
  include ActivePodio::Updatable

  property :task_id, :integer
  property :status, :string
  property :group, :string
  property :text, :string
  property :description, :string
  property :private, :boolean
  property :due_date, :date
  property :due_on, :datetime, :convert_incoming_local_datetime_to_utc => true
  property :responsible, :hash
  property :space_id, :integer
  property :link, :string
  property :created_on, :datetime
  property :completed_on, :datetime
  property :file_ids, :array # when inputting tasks
  property :label_ids, :array # when inputting tasks
  property :labels, :array # when outputting tasks
  property :external_id, :string

  # old references
  property :ref_type, :string
  property :ref_id, :integer
  property :ref_title, :string
  property :ref_link, :string

  # new reference
  property :ref, :hash

  has_one :created_by, :class => 'User'
  has_one :completed_by, :class => 'User'
  has_one :created_via, :class => 'Via'
  has_one :deleted_via, :class => 'Via'
  has_one :completed_via, :class => 'Via'
  has_one :assignee, :class => 'User', :property => :responsible
  has_many :label_list, :class => 'TaskLabel', :property => :labels 
  has_many :files, :class => 'FileAttachment'
  has_many :comments, :class => 'Comment'
  has_one :reminder, :class => 'Reminder'
  has_one :recurrence, :class => 'Recurrence'

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

  def delete_reference
    self.class.delete_reference(self.id)
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

    def update_due_on(id, due_on)
      Podio.connection.put("/task/#{id}/due_on", {:due_on => due_on}).status
    end

    def update_assignee(id, user_id)
      Podio.connection.post("/task/#{id}/assign", {:responsible => user_id}).status
    end

    def update_reference(id, ref_type, ref_id)
      Podio.connection.put("/task/#{id}/ref", {:ref_type => ref_type, :ref_id => ref_id}).status
    end

    def delete_reference(task_id)
      Podio.connection.delete("/task/#{task_id}/ref").status
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

    def suggested_ref(query, space_limit, item_limit)
      response = Podio.connection.post do |req|
        req.url "/task/suggested_ref/"
        req.body = {
            :text => query,
            :space_limit => space_limit,
            :item_limit => item_limit
        }
      end

      response.body
    end

    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/task/', options)
      }.body
    end
    
    def find_summary
      response = Podio.connection.get("/task/summary").body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end

    def find_summary_for_org(org_id, limit=nil)
      response = Podio.connection.get("/task/org/#{org_id}/summary" + 
                                      ((limit != nil) ? "?limit=#{limit}" : "")).body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response      
    end
    
    def find_summary_for_reference(ref_type, ref_id)
      response = Podio.connection.get("/task/#{ref_type}/#{ref_id}/summary").body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end
    
    def find_personal_summary
      response = Podio.connection.get("/task/personal/summary").body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end
    
  end
end
