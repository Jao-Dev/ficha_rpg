class CreateRelationships < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      add_reference :characters, :user, foreign_key: true
      add_reference :characters, :campaign, foreign_key: true
    end
  end
end
