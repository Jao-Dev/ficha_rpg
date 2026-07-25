require 'factory_bot'

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "#{name.parameterize(separator: '.')}@ficha_rpg.com" }
  end

  factory :character do
    name { 'Yudmit Longfeet' }
    race { 'Dwarf' }
    ativo { true }

    trait :inativo do
      ativo { false }
    end
  end

  factory :campaign do
    master { 'Mestre boladão' }
    ativo { true }

    trait :inativo do
      ativo { false }
    end
  end
end
