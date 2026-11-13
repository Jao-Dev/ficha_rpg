class CampaignPolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    admin? || master?
  end

  def destroy?
    admin? || master?
  end

  private

  def master?
    record.master == user
  end
end
