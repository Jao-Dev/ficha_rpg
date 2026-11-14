class CampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_campaign, only: [ :show, :edit, :update, :destroy ]
  after_action :verify_authorized

  def show
  end

  def index
    campanhas_de_personagens = CampaignCharacter.ativo
      .where(character_id: current_user.character_ids).select(:campaign_id)

    @campanhas = Campaign.where(master: current_user)
      .or(Campaign.where(id: campanhas_de_personagens)).includes(:master)
    @pendentes = CampaignCharacter.pendente
      .where(character_id: current_user.character_ids).includes(:character, campaign: :master)
    authorize Campaign.new
  end

  def edit
    if params[:q].present?
      @resultados = Character.where(campaign_id: nil)
        .where("name ILIKE ?", "%#{params[:q]}%").includes(:user).order(:name)
    end
  end

  def create
    @campaign = Campaign.new(master: current_user)
    authorize @campaign

    @campaign.save!
    redirect_to campaign_path(@campaign), notice: "Campanha criada com sucesso."
  end

  def update
    @campaign.update!(campaign_params)
    redirect_to campaign_path(@campaign), notice: "Campanha atualizada com sucesso."
  end

  def destroy
    if @campaign.destroy
      redirect_to root_path, notice: "Campanha excluída com sucesso."
    else
      redirect_to campaign_path(@campaign), alert: "Não foi possível excluir a campanha."
    end
  end

  private

  def set_campaign
    @campaign = Campaign.find(params[:id])
    authorize @campaign
  end

  def campaign_params
    params.require(:campaign).permit(:ativo)
  end
end
