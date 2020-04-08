FactoryBot.define do
  factory :service do
    description { Faker::Movies::StarWars.quote }

    factory :single_offer, class: 'Services::SingleOffers::SingleOfferService' do
      name { 'Услуга покупки' }
      price { Money.new(1_000, 'HUF') }
    end

    factory :subscription, class: 'Services::Subscriptions::SubscriptionService' do
      trait :for_30_days do
        name { 'Подписка на 30 дней' }
        duration { 30 }
        price { Money.new(5_000, 'HUF') }
      end

      trait :for_60_days do
        name { 'Подписка на 60 дней' }
        duration { 60 }
        price { Money.new(9_000, 'HUF') }
      end

      trait :for_90_days do
        name { 'Подписка на 90 дней' }
        duration { 90 }
        price { Money.new(13_000, 'HUF') }
      end
    end
  end
end
