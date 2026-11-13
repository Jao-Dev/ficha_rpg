class AddUnconfirmedEmailToUsers < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      add_column :users, :unconfirmed_email, :string
    end
  end
end
