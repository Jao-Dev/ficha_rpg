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
end
