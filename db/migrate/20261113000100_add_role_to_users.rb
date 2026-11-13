class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      add_column :users, :role, :integer, null: false, default: 0
    end
  end
end
