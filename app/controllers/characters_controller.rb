class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character,
    only: [ :show, :edit, :update, :destroy, :alternar,
            :adicionar_item, :atualizar_item, :remover_item,
            :adicionar_arma, :atualizar_arma, :remover_arma,
            :adicionar_efeito, :atualizar_efeito, :remover_efeito ]
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

  def adicionar_item
    salvar_lista(:mochila, @character.mochila + [ item_params ], "Item adicionado à mochila.", "Item inválido.")
  end

  def atualizar_item
    salvar_lista(:mochila, substituir_em(@character.mochila, item_params), "Item atualizado.", "Item inválido.")
  end

  def remover_item
    salvar_lista(:mochila, remover_indice(@character.mochila), "Item removido da mochila.", "Item inválido.")
  end

  def adicionar_arma
    salvar_lista(:armas, @character.armas + [ arma_params ], "Arma adicionada.", "Arma inválida.")
  end

  def atualizar_arma
    salvar_lista(:armas, substituir_em(@character.armas, arma_params), "Arma atualizada.", "Arma inválida.")
  end

  def remover_arma
    salvar_lista(:armas, remover_indice(@character.armas), "Arma removida.", "Arma inválida.")
  end

  def adicionar_efeito
    salvar_lista(:efeitos, @character.efeitos + [ params[:efeito] ], "Efeito adicionado.", "Efeito inválido.")
  end

  def atualizar_efeito
    salvar_lista(:efeitos, substituir_em(@character.efeitos, params[:efeito]), "Efeito atualizado.", "Efeito inválido.")
  end

  def remover_efeito
    salvar_lista(:efeitos, remover_indice(@character.efeitos), "Efeito removido.", "Efeito inválido.")
  end

  private

  def set_character
    @character = Character.find(params[:id])
    authorize @character
  end

  def salvar_lista(tipo, lista, sucesso, falha)
    if @character.update(extras: @character.extras.merge(tipo.to_s => lista))
      redirect_to user_character_path(current_user, @character), notice: sucesso
    else
      redirect_to user_character_path(current_user, @character), alert: falha
    end
  end

  def substituir_em(lista, item)
    lista.dup.tap { |copia| copia[params[:indice].to_i] = item }
  end

  def remover_indice(lista)
    lista.dup.tap { |copia| copia.delete_at(params[:indice].to_i) }
  end

  def item_params
    { "nome" => params[:item], "quantidade" => params[:quantidade].to_i }
  end

  def arma_params
    { "nome" => params[:arma], "dano" => params[:dano] }
  end

  def character_params
    params.require(:character).permit(:name, :race, :campaign_id, :avatar, :anotacoes, :historia)
  end
end
