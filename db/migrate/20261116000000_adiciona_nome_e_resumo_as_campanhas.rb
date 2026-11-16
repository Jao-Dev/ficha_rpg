class AdicionaNomeEResumoAsCampanhas < ActiveRecord::Migration[8.1]
  def change
    add_column :campaigns, :nome, :string, null: false, default: ""
    add_column :campaigns, :resumo, :text
  end
end
