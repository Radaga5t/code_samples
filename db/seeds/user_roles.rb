## Создаем группу администраторов
UserRole.create(
  name: 'Администратор',
  slug: 'administrator',
  god_mode: 'true',
  immutable: true
) if UserRole.where(slug: 'administrator').size == 0

## Создаем группу модераторов
UserRole.create(
  name: 'Модератор',
  slug: 'moderator',
  immutable: true
) if UserRole.where(slug: 'moderator').size == 0

## Создаем группу модераторов
UserRole.create(
  name: 'Исполнитель',
  slug: 'executor',
  immutable: true
) if UserRole.where(slug: 'executor').size == 0

## Создаем группу пользователей
UserRole.create(
  name: 'Пользователь',
  slug: 'user',
  immutable: true
) if UserRole.where(slug: 'user').size == 0