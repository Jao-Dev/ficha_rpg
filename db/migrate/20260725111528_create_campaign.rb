class CreateCampaign < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :master, null: false
      t.boolean :ativo, default: true, null: false

      t.timestamps
    end
  end
end
