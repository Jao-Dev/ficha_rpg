module ApplicationHelper
  def personagem_em_uso
    return unless user_signed_in? && session[:character_id]

    current_user.characters.find_by(id: session[:character_id])
  end
end
