class AdicionaTipoAoAviso < ActiveRecord::Migration[8.1]
  def change
    add_column :avisos, :tipo, :integer, null: false, default: 0
  end
end
