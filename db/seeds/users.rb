User.create(
  name: 'x',
  email: 'x',
  password: 'x',
  immutable: true,
  user_roles: UserRole.where(slug: 'administrator')
) if User.all.size == 0
