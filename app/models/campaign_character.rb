class CampaignCharacter < ApplicationRecord
  audited

  belongs_to :campaign
  belongs_to :character

  enum :status, %i[pendente ativo]
end
