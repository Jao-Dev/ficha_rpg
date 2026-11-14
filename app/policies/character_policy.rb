class CharacterPolicy < ApplicationPolicy
  def show?
    admin? || owner? || campaign_master?
  end

  def create?
    admin? || owner?
  end

  def update?
    admin? || owner?
  end

  def alternar?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  private

  def owner?
    record.user == user
  end

  def campaign_master?
    record.campaign && record.campaign.master == user
  end
end
