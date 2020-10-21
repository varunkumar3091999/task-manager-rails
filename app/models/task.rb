class Task < ApplicationRecord
  # Relationships
  belongs_to :user
  has_many :sub_tasks, :class_name => "Task", :foreign_key => :parent_id
  has_one :image
  accepts_nested_attributes_for :image, allow_destroy: true

  # Validations
  validates :title, presence: true
  validates :description, presence: true


  # Scopes
  scope :parent_tasks, -> { where(parent_id: nil) }

  # Customization
  enum status: {pending: 0, completed: 1}

  # Callbacks
  before_validation :set_defaults

  def normalize_parent_task
    if self.parent_id.present?
      pending_tasks = Task.where(parent_id: self.parent_id, status: :pending)
      if pending_tasks.count <= 0
        parent = Task.find_by(id: self.parent_id)
        parent.update(status: :completed)
      end
    end
  end

  def parent
    if self.parent_id.present?
      Task.find_by(id: parent_id)
    end
  end

  private
  def set_defaults
    self.status ||= :pending
  end
end