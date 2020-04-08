# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    name { Faker::TvShows::DrWho.character }
    description { Faker::Lorem.paragraphs(number: 5) }
    active { true }

    trait :invalid do
      slug { "\\~\`!@\"@#$%^&*()+=\-_" }
    end

    trait :child do
      # parent { Category.create || association(:category) }
      association :parent, factory: :category
    end

    trait :with_task_templates do
      transient do
        templates_count { 2 }
      end

      after(:create) do |category, evaluator|
        create_list(:task_template,
                    evaluator.templates_count,
                    :with_template,
                    categories: [category])
      end
    end
  end
end
