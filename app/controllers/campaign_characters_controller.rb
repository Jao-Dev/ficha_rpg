class CampaignCharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign
  after_action :verify_authorized

  def create
    authorize CampaignCharacter.new(campaign: @campaign)

    character = Character.find(params[:character_id])

    if character.campaign_id
      redirect_to edit_campaign_path(@campaign), alert: "Personagem já está em uma campanha."
    else
      CampaignCharacter.create!(campaign: @campaign, character: character, status: :pendente)
      character.update!(campaign: @campaign)
      Aviso.create!(user: character.user,
        content: "Seu personagem #{character.name} foi inserido na campanha de #{@campaign.master.name}.")
      redirect_to edit_campaign_path(@campaign), notice: "Personagem adicionado. Aguardando confirmação do dono."
    end
  end

  def update
    vinculo = @campaign.campaign_characters.find(params[:id])
    authorize vinculo

    vinculo.update!(status: :ativo)
    Aviso.create!(user: @campaign.master,
      content: "#{vinculo.character.user.name} confirmou o personagem #{vinculo.character.name} na sua campanha.")
    redirect_to campaigns_path, notice: "Personagem confirmado na campanha."
  end

  def destroy
    vinculo = @campaign.campaign_characters.find(params[:id])
    authorize vinculo
    recusado = vinculo.character.user == current_user
    dono = vinculo.character.user
    nome = vinculo.character.name
    vinculo.destroy!
    vinculo.character.update!(campaign: nil)

    if recusado
      Aviso.create!(user: @campaign.master, content: "#{dono.name} recusou o personagem #{nome} na sua campanha.")
      redirect_to campaigns_path, notice: "Participação recusada."
    else
      Aviso.create!(user: dono,
        content: "Seu personagem #{nome} foi removido da campanha de #{@campaign.master.name}.")
      redirect_to edit_campaign_path(@campaign), notice: "Personagem removido da campanha."
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
