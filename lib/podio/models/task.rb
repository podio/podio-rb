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

  def update_attribute(field, value)
    case field
    when 'text'
      Task.update_text(id, value)
      true
    when 'description'
      Task.update_description(id, value)
      true
    when 'private'
      begin
        Task.update_private(id, value.to_b)
        true
      rescue Podio::BadRequestError
        # don't care if we change to same state again
      end
    when 'due_date'
      Task.update_due_date(id, value)
      when 'assignee'
        if self.private && value.empty?
          self.error_message = _('You cannot remove the responsible on private tasks #tasks')
          false
        else
          Task.update_assignee(id, value.to_i)
          true
        end
    end
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

  def self.find_mine(user, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 0, :responsible => user.user_id}.merge(options)).group_by(&:group)
  end

  def self.find_delegated(user, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 0, :reassigned => 1}.merge(options)).group_by(&:group)
  end

  def self.find_completed(user, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 1, :completed_by => 'user:0'}.merge(options)).group_by(&:group)
  end

  def self.find_completedbyothers(user, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'responsible'
    Task.find_all({:completed => 1, :created_by => 'user:0'}.merge(options)).group_by(&:group)
  end

  def self.find_for_space(space, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'responsible'
    Task.find_all({:completed => 0, :space => space.id}.merge(options)).group_by(&:group)
  end

  def self.find_mine_for_space(user, space, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 0, :responsible => user.user_id, :space => space.id}.merge(options)).group_by(&:group)
  end

  def self.find_mine_completed_for_space(user, space, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 1, :responsible => user.user_id, :space => space.id}.merge(options)).group_by(&:group)
  end

  def self.find_delegated_for_space(user, space, options={})
    options[:offset] ||= 0
    options[:grouping] ||= 'due_date'
    Task.find_all({:completed => 0, :reassigned => 1, :space => space.id}.merge(options)).group_by(&:group)
  end
end
