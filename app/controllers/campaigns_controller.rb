class CampaignsController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def show
    @campaign = Campaign.find(params[:id])
    authorize @campaign
  end

  def create
    @campaign = Campaign.new(master: current_user)
    authorize @campaign

    @campaign.save!
    redirect_to campaign_path(@campaign), notice: "Campanha criada com sucesso."
  end
end
