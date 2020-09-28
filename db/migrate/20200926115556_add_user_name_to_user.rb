class AddUserNameToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_name, :string, default: ""
  end
end
