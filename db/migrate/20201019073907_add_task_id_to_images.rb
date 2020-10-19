class AddTaskIdToImages < ActiveRecord::Migration[5.2]
  def change
    add_reference :images, :task, foreign_key: true
  end
end
