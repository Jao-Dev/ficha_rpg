class AdicionaExtrasAnotacoesEHistoriaAosPersonagens < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :extras, :jsonb, null: false, default: {}
    add_column :characters, :anotacoes, :text
    add_column :characters, :historia, :text
  end
end
