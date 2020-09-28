json.extract! task, :id, :title, :description, :status, :assignee, :assigner, :parent_id, :created_at, :updated_at
json.url task_url(task, format: :json)
