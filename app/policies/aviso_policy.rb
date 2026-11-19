class AvisoPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user == record.user
  end
end
