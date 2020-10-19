class Image < ApplicationRecord
  belongs_to :task, foreign_key: 'task_id'
  mount_uploader :image, ImageUploader
end