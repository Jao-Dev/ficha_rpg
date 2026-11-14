class Aviso < ApplicationRecord
  audited

  belongs_to :user

  validates :content, presence: true

  scope :lidos, -> { where.not(read_at: nil) }
  scope :nao_lidos, -> { where(read_at: nil) }
end
