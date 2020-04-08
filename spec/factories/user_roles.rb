FactoryBot.define do
  factory :user_role_user, class: UserRole do
    name { 'Пользователь' }
    slug { 'user' }
  end

  factory :user_role_moderator, class: UserRole do
    name { 'Модератор' }
    slug { 'moderator' }
  end

  factory :user_role_administrator, class: UserRole do
    name { 'Администратор' }
    slug { 'administrator' }
    god_mode { true }
  end

  factory :user_role_executor, class: UserRole do
    name { 'Исполнитель' }
    slug { 'executor' }
    god_mode { true }
  end
end
