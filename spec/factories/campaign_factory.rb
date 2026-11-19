FactoryBot.define do
  factory :campaign do
    nome { Faker::Lorem.words(number: 2).join(' ') }
    association :master, factory: :user
    ativo { true }

    trait :inativo do
      ativo { false }
    end
  end
end
