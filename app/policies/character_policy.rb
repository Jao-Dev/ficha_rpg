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

  def adicionar_item?
    admin? || owner?
  end

  def atualizar_item?
    admin? || owner?
  end

  def remover_item?
    admin? || owner?
  end

  def adicionar_arma?
    admin? || owner?
  end

  def atualizar_arma?
    admin? || owner?
  end

  def remover_arma?
    admin? || owner?
  end

  def adicionar_efeito?
    admin? || owner?
  end

  def atualizar_efeito?
    admin? || owner?
  end

  def remover_efeito?
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
