# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    name { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    birthday { Faker::Date.birthday }
    price_per_hour { Money.new(Faker::Number.within(range: 500..10_000), 'HUF') }
    about { Faker::Movies::StarWars.quote }
    password { Faker::Internet.password }

    trait :male do
      sex { :male }
    end

    trait :individual do
      user_type { :individual }
    end

    trait :legal_entity do
      user_type { :legal_entity }
    end

    trait :from_russia do
      association :country, factory: %i[country russia]
    end

    trait :has_2_lang do
      after :create do |user|
        user.languages << [create(:language), create(:eng_language)]
      end
    end

    trait :immutable do
      immutable { true }
    end

    trait :administrator do
      after :create do |user|
        user.user_roles << (UserRole.where(slug: 'administrator').first ||
          create(:user_role_administrator))
      end
    end

    trait :moderator do
      after :create do |user|
        user.user_roles << (UserRole.where(slug: 'moderator').first ||
          create(:user_role_moderator))
      end
    end

    trait :executor do
      after :create do |user|
        user.user_roles << (UserRole.where(slug: 'executor').first ||
          create(:user_role_executor))
      end
    end

    trait :user do
      after :create do |user|
        user.user_roles << (UserRole.where(slug: 'user').first ||
          create(:user_role_user))
      end
    end
  end
end
