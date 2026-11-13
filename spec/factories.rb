require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.parameterize(separator: '.')}@ficha_rpg.com" }
    password { 'teste123' }
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
