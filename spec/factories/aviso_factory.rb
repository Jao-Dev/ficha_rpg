FactoryBot.define do
  factory :aviso do
    user
    tipo { :inserido }
    content { 'Seu personagem foi inserido em uma campanha.' }

    trait :inserido do
      tipo { :inserido }
      content { 'Seu personagem Belerion foi inserido na campanha de Mestre Um.' }
    end

    trait :confirmado do
      tipo { :confirmado }
      content { 'Dono Um confirmou o personagem Belerion na sua campanha.' }
    end

    trait :recusado do
      tipo { :recusado }
      content { 'Dono Um recusou o personagem Belerion na sua campanha.' }
    end

    trait :removido do
      tipo { :removido }
      content { 'Seu personagem Belerion foi removido da campanha de Mestre Um.' }
    end
  end
end
