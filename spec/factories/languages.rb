FactoryBot.define do
  factory :language do
    name_ru { 'Русский' }
    name_en { 'Russian' }
    name_hu { 'Orosz' }

    factory :eng_language do
      name_ru { 'Английский' }
      name_en { 'English' }
      name_hu { 'Angol' }
    end
  end
end
