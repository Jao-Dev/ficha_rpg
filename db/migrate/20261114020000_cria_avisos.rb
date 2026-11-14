class CriaAvisos < ActiveRecord::Migration[8.1]
  def change
    create_table :avisos do |t|
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.datetime :read_at

      t.timestamps
    end
  end
end
