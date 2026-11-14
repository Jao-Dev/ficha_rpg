class Character < ApplicationRecord
  audited

  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg" ].freeze

  belongs_to :user
  belongs_to :campaign, optional: true

  has_many :campaign_characters, dependent: :destroy

  has_one_attached :avatar

  validates :name, :race, presence: true
  validates :avatar,
    content_type: {
      in: ACCEPTED_CONTENT_TYPES,
      spoofing_protection: true,
      message: "deve ser uma imagem PNG ou JPEG"
    }

  after_save :sincroniza_vinculo, if: :saved_change_to_campaign_id?

  private

  def sincroniza_vinculo
    campaign_characters.where.not(campaign_id: campaign_id).destroy_all

    if campaign
      campaign_characters.find_or_create_by!(campaign: campaign) { |vinculo| vinculo.status = :ativo }
    end
  end
end
