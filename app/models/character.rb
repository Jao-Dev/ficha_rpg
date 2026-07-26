class Character < ApplicationRecord
  audited

  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg" ].freeze

  belongs_to :user
  belongs_to :campaign

  has_one_attached :avatar

  validates :name, :race, :ativo, presence: true
  validates :avatar,
    content_type: { in:
    ACCEPTED_CONTENT_TYPES,
    spoofin_protection: true
    }
end
