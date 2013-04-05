# @see https://developers.podio.com/doc/tasks
class Podio::Task < ActivePodio::Base
  include ActivePodio::Updatable

  property :task_id, :integer
  property :status, :string
  property :group, :string
  property :text, :string
  property :description, :string
  property :rights, :array
  property :private, :boolean
  property :due_date, :date
  property :due_time, :time
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
  property :subscribed, :boolean
  property :subscribed_count, :integer
  property :pinned, :boolean
  property :push, :hash
  property :presence, :hash

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

  # @see https://developers.podio.com/doc/tasks/create-task-22419
  def create
    result = self.create_multiple # Could return false if API call failed
    self.task_id = result.first.id if result
    result
  end

  def create_multiple
    compacted_attributes = remove_nil_values(self.attributes)
    if(self.ref_type.present? && self.ref_id.present?)
      self.class.create_with_ref(self.ref_type, self.ref_id, compacted_attributes)
    else
      self.class.create(compacted_attributes)
    end
  end

  # @see https://developers.podio.com/doc/tasks/delete-task-77179
  def destroy
    self.class.delete(self.id)
  end

  # @see https://developers.podio.com/doc/tasks/update-task-reference-170733
  def update_reference(ref_type, ref_id)
    self.class.update_reference(self.id, ref_type, ref_id)
  end

  # @see https://developers.podio.com/doc/tasks/remove-task-reference-6146114
  def delete_reference
    self.class.delete_reference(self.id)
  end

  # @see https://developers.podio.com/doc/tasks/update-task-labels-151769
  def update_labels(label_ids)
    self.class.update_labels(self.id, label_ids)
  end

  # @see https://developers.podio.com/doc/tasks/complete-task-22432
  def complete
    self.class.complete(self.id)
  end

  # @see https://developers.podio.com/doc/tasks/incomplete-task-22433
  def uncomplete
    self.class.incomplete(self.id)
  end

  # @see https://developers.podio.com/doc/tasks/rank-task-81015
  def rank(previous_task, next_task)
    self.class.rank(self.id, previous_task && previous_task.to_i, next_task && next_task.to_i)
  end

  class << self
    # @see https://developers.podio.com/doc/tasks/create-task-22419
    def create(attributes)
      response = Podio.connection.post do |req|
        req.url "/task/"
        req.body = attributes
      end

      list [response.body].flatten
    end

    # @see https://developers.podio.com/doc/tasks/create-task-with-reference-22420
    def create_with_ref(ref_type, ref_id, attributes)
      response = Podio.connection.post do |req|
        req.url "/task/#{ref_type}/#{ref_id}/"
        req.body = attributes
      end

      list [response.body].flatten
    end

    # @see https://developers.podio.com/doc/tasks/update-task-description-76982
    def update_description(id, description)
      Podio.connection.put("/task/#{id}/description", {:description => description}).status
    end

    # @see https://developers.podio.com/doc/tasks/update-task-text-22428
    def update_text(id, text)
      Podio.connection.put("/task/#{id}/text", {:text => text}).status
    end

    # @see https://developers.podio.com/doc/tasks/update-task-private-22434
    def update_private(id, private_flag)
      Podio.connection.put("/task/#{id}/private", {:private => private_flag}).status
    end

    def update_due_date(id, due_date)
      Podio.connection.put("/task/#{id}/due_date", {:due_date => due_date}).status
    end

    # @see https://developers.podio.com/doc/tasks/update-task-due-on-3442633
    def update_due_on(id, options)
      Podio.connection.put("/task/#{id}/due_on", options).status
    end

    # @see https://developers.podio.com/doc/tasks/assign-task-22412
    def update_assignee(id, user_id)
      Podio.connection.post("/task/#{id}/assign", {:responsible => user_id}).status
    end

    # @see https://developers.podio.com/doc/tasks/update-task-reference-170733
    def update_reference(id, ref_type, ref_id)
      Podio.connection.put("/task/#{id}/ref", {:ref_type => ref_type, :ref_id => ref_id}).status
    end

    # @see https://developers.podio.com/doc/tasks/remove-task-reference-6146114
    def delete_reference(task_id)
      Podio.connection.delete("/task/#{task_id}/ref").status
    end

    # @see https://developers.podio.com/doc/tasks/update-task-labels-151769
    def update_labels(id, label_ids)
      Podio.connection.put("/task/#{id}/label/", label_ids).status
    end

    # @see https://developers.podio.com/doc/tasks/delete-task-77179
    def delete(id)
      Podio.connection.delete("/task/#{id}").status
    end

    # @see https://developers.podio.com/doc/tasks/complete-task-22432
    def complete(id)
      Podio.connection.post("/task/#{id}/complete").body
    end

    # @see https://developers.podio.com/doc/tasks/incomplete-task-22433
    def incomplete(id)
      Podio.connection.post("/task/#{id}/incomplete").body
    end

    # @see https://developers.podio.com/doc/tasks/rank-task-81015
    def rank(id, before_task_id, after_task_id)
      Podio.connection.post("/task/#{id}/rank", {:before => before_task_id, :after => after_task_id}).body
    end

    # @see https://developers.podio.com/doc/tasks/get-task-22413
    def find(id, options = {})
      member Podio.connection.get("/task/#{id}", options).body
    end

    # @see https://developers.podio.com/doc/tasks/get-tasks-with-reference-22426
    def find_for_reference(ref_type, ref_id)
      list Podio.connection.get("/task/#{ref_type}/#{ref_id}/").body
    end

    # @see https://developers.podio.com/doc/tasks/get-tasks-77949
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/task/', options)
      }.body
    end

    # @see https://developers.podio.com/doc/tasks/get-task-summary-1612017
    def find_summary
      response = Podio.connection.get("/task/summary").body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end

    # @see https://developers.podio.com/doc/tasks/get-task-summary-for-organization-1612063
    def find_summary_for_org(org_id, limit=nil)
      response = Podio.connection.get("/task/org/#{org_id}/summary" +
                                      ((limit != nil) ? "?limit=#{limit}" : "")).body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end

    # @see https://developers.podio.com/doc/tasks/get-task-summary-for-reference-1657980
    def find_summary_for_reference(ref_type, ref_id, options = {})
      response = Podio.connection.get { |req|
        req.url("/task/#{ref_type}/#{ref_id}/summary", options)
      }.body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end

    # @see https://developers.podio.com/doc/tasks/get-task-summary-for-personal-1657217
    def find_personal_summary
      response = Podio.connection.get("/task/personal/summary").body
      response['overdue']['tasks'] = list(response['overdue']['tasks'])
      response['today']['tasks'] = list(response['today']['tasks'])
      response['other']['tasks'] = list(response['other']['tasks'])
      response
    end

    # @see https://developers.podio.com/doc/tasks/get-task-count-38316458
    def count_by_ref(ref_type, ref_id)
      Podio.connection.get("/task/#{ref_type}/#{ref_id}/count").body['count']
    end

  end
end
