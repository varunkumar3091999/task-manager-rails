class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.string :status
      t.integer :assignee
      t.integer :assigner
      t.integer :parent_id

      t.timestamps
    end
  end
end
