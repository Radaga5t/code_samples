# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    transient do
      user { create(:user) }
      category { create(:category) }
      form_data { [] }
    end

    title { Faker::Movies::Lebowski.actor }
    description { Faker::Movies::Lebowski.quote }
    private_text { Faker::Movies::Lebowski.quote }

    user_id { user.id }
    category_id { category.id }

    budget { Money.new(10_000, 'HUF') }

    phone { Faker::PhoneNumber.cell_phone_with_country_code }

    contractor_documents_required { true }
    send_email_notifications { true }
    send_viber_notifications { true }
    show_for_contractors_only { false }

    trait :published do
      status { :published }
      published_at { Time.current }
      published_until { published_at + (lifetime || 7).days }
    end

    trait :closed do
      closed_at { Time.current }
      customer_close_mark { :failed }
      contractor_close_mark { :solved }

      after(:create) do |task|
        task.update_attribute(:status, :closed)
      end
    end
  end
end
