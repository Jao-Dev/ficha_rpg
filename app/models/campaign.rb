class Campaign < ApplicationRecord
  audited

  has_many :characters

  belongs_to :master, class_name: "User"

  validates :ativo, presence: true
end
