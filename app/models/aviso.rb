class Aviso < ApplicationRecord
  audited

  belongs_to :user

  enum :tipo, %i[inserido confirmado recusado removido], validate: true

  validates :content, presence: true
  validates :tipo, presence: true

  scope :lidos, -> { where.not(read_at: nil) }
  scope :nao_lidos, -> { where(read_at: nil) }
end
