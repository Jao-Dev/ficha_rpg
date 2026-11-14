class AvisosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Aviso

    current_user.avisos.nao_lidos.find_each { |aviso| aviso.update!(read_at: Time.current) }
    @avisos = current_user.avisos.order(created_at: :desc)
  end
end
