class Campaign < ApplicationRecord
  audited

  has_many :characters, dependent: :restrict_with_error
  has_many :campaign_characters, dependent: :destroy

  belongs_to :master, class_name: "User"

  validates :ativo, inclusion: { in: [ true, false ] }
end
