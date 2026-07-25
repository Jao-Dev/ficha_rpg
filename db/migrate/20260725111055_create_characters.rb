class CreateCharacters < ActiveRecord::Migration[8.1]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :race, null: false
      t.boolean :ativo, default: true, null: false

      t.timestamps
    end
  end
end
