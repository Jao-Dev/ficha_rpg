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
    ativo { true }
    user
    campaign

    trait :inativo do
      ativo { false }
    end
  end

  factory :campaign do
    association :master, factory: :user
    ativo { true }

    trait :inativo do
      ativo { false }
    end
  end
end
