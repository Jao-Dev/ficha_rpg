class Character < ApplicationRecord
  audited

  validates :name, :race, :ativo, presence: true
end
