FactoryBot.define do
  factory :promocode do
    sequence(:label) { |n| "promocode-#{n}" }
    transient do
      set_amount { 0 }
      max_uses { 0 }
      uses { 0 }
      active { nil }
    end
    trait :absolute do
      type_of_discount { :absolute }
      amount { Money.new(set_amount, 'HUF') }
      max_count_of_uses { max_uses }
      count_of_uses { uses }
      active_until { active }
    end
    trait :relative do
      type_of_discount { :relative }
      relative_amount { set_amount }
      max_count_of_uses { max_uses }
      count_of_uses { uses }
      active_until { active }
    end
  end
end
