class Campaign < ApplicationRecord
  audited

  has_many :characters

  validates :master, :ativo, presence: true
end
