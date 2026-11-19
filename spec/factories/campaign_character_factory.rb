FactoryBot.define do
  factory :campaign_character do
    campaign
    character
    status { :pendente }

    trait :ativo do
      status { :ativo }
    end
  end
end
