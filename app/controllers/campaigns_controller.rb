class CampaignsController < ApplicationController
  before_action :authenticate_user!

  def show
    @campaign = Campaign.find(params[:id])
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campanha criada com sucesso."
    else
      flash.now[:alert] = "Não foi possível salvar a campanha."
      render :new, status: :unprocessable_entity
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:master)
  end
end
