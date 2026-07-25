class Campaign < ApplicationRecord
  audited

  validates :master, :ativo, presence: true
end
