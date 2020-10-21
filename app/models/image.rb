class Image < ApplicationRecord
  belongs_to :task, :class_name => "Task", :foreign_key => "task_id"
  mount_uploader :image, ImageUploader
end