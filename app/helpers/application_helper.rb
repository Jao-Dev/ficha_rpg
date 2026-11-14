module ApplicationHelper
  def personagem_em_uso
    return unless user_signed_in? && session[:character_id]

    current_user.characters.find_by(id: session[:character_id])
  end

  def rotulo_avisos
    nao_lidos = current_user.avisos.nao_lidos.count
    nao_lidos.zero? ? "Avisos" : "Avisos (#{nao_lidos})"
  end
end
