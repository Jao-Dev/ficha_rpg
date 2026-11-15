class Character < ApplicationRecord
  audited

  ACCEPTED_CONTENT_TYPES = [ "image/png", "image/jpeg" ].freeze
  EXTRAS_CHAVES = %w[mochila armas efeitos].freeze

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

  validate :valida_extras

  after_save :sincroniza_vinculo, if: :saved_change_to_campaign_id?

  def mochila
    extras["mochila"] || []
  end

  def armas
    extras["armas"] || []
  end

  def efeitos
    extras["efeitos"] || []
  end

  private

  def valida_extras
    return adiciona_erro_extras unless extras.is_a?(Hash)
    return adiciona_erro_extras unless extras.keys.all? { |chave| EXTRAS_CHAVES.include?(chave) }

    valida_mochila
    valida_armas
    valida_efeitos
  end

  def adiciona_erro_extras
    errors.add :extras, :invalid
  end

  def valida_mochila
    return adiciona_erro_extras unless mochila.is_a?(Array)

    mochila.each do |item|
      next if item.is_a?(Hash) && item["nome"].present? && item["quantidade"].is_a?(Integer) && item["quantidade"] >= 0

      adiciona_erro_extras
      break
    end
  end

  def valida_armas
    return adiciona_erro_extras unless armas.is_a?(Array)

    armas.each do |arma|
      next if arma.is_a?(Hash) && arma["nome"].present? && arma["dano"].present?

      adiciona_erro_extras
      break
    end
  end

  def valida_efeitos
    return adiciona_erro_extras unless efeitos.is_a?(Array)

    efeitos.each do |efeito|
      next if efeito.is_a?(String) && efeito.present?

      adiciona_erro_extras
      break
    end
  end

  def sincroniza_vinculo
    campaign_characters.where.not(campaign_id: campaign_id).destroy_all

    if campaign
      campaign_characters.find_or_create_by!(campaign: campaign) { |vinculo| vinculo.status = :ativo }
    end
  end
end
