class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [ :show, :edit, :update, :destroy, :alternar ]
  after_action :verify_authorized

  def show
  end

  def new
    @character = current_user.characters.new
    authorize @character
  end

  def create
    @character = current_user.characters.new(character_params)
    authorize @character

    if @character.save
      redirect_to user_character_path(current_user, @character), notice: "Personagem criado com sucesso."
    else
      flash.now[:alert] = "Não foi possível salvar o personagem."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @character.update(character_params)
      redirect_to user_character_path(current_user, @character), notice: "Personagem atualizado com sucesso."
    else
      flash.now[:alert] = "Não foi possível salvar o personagem."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy
    redirect_to root_path, notice: "Personagem excluído com sucesso."
  end

  def alternar
    session[:character_id] = @character.id
    redirect_to root_path, notice: "Você agora está usando #{@character.name}."
  end

  private

  def set_character
    @character = Character.find(params[:id])
    authorize @character
  end

  def character_params
    params.require(:character).permit(:name, :race, :campaign_id, :avatar)
  end
end
