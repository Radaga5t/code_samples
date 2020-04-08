FactoryBot.define do
  factory :country do
    name_ru { 'Венгрия' }
    name_en { 'Hungary' }
    name_hu { 'Magyarország' }

    trait :russia do
      name_ru { 'Россия' }
      name_en { 'Russia' }
      name_hu { 'Oroszország' }
    end
  end
end
