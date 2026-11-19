class AvisosController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize Aviso

    @avisos = current_user.avisos.order(created_at: :desc)
  end

  def show
    @aviso = current_user.avisos.find(params[:id])
    authorize @aviso
    @aviso.update!(read_at: Time.current) unless @aviso.read_at
  end
end
