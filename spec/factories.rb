require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.parameterize(separator: '.')}@ficha_rpg.com" }
    password { 'teste123' }
    confirmed_at { Time.current }

    role { :jogador }

    trait :mestre do
      role { :mestre }
    end

    trait :admin do
      role { :admin }
    end

    trait :sem_confirmacao do
      confirmed_at { nil }
    end
  end

  factory :character do
    name { 'Yudmit Longfeet' }
    race { 'Dwarf' }
    user
  end

  factory :campaign_character do
    campaign
    character
    status { :pendente }

    trait :ativo do
      status { :ativo }
    end
  end

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

  factory :campaign do
    nome { Faker::Lorem.words(number: 2).join(' ') }
    association :master, factory: :user
    ativo { true }

    trait :inativo do
      ativo { false }
    end
  end
end
