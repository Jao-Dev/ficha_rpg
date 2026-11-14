class CampaignCharacterPolicy < ApplicationPolicy
  def create?
    admin? || campaign_master?
  end

  def update?
    admin? || record.character.user == user
  end

  def destroy?
    admin? || campaign_master? || record.character.user == user
  end

  private

  def campaign_master?
    record.campaign.master == user
  end
end
