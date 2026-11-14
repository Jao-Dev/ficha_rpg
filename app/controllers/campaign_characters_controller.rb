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
      redirect_to edit_campaign_path(@campaign), notice: "Personagem adicionado. Aguardando confirmação do dono."
    end
  end

  def update
    vinculo = @campaign.campaign_characters.find(params[:id])
    authorize vinculo

    vinculo.update!(status: :ativo)
    redirect_to campaigns_path, notice: "Personagem confirmado na campanha."
  end

  def destroy
    vinculo = @campaign.campaign_characters.find(params[:id])
    authorize vinculo
    recusado = vinculo.character.user == current_user
    vinculo.destroy!
    vinculo.character.update!(campaign: nil)

    if recusado
      redirect_to campaigns_path, notice: "Participação recusada."
    else
      redirect_to edit_campaign_path(@campaign), notice: "Personagem removido da campanha."
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:campaign_id])
  end
end
