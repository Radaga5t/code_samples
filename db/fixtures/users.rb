100.times.map do
  u = User.create(
    name: Faker::Name.first_name,
    lastname:  Faker::Name.last_name,
    phone: Faker::PhoneNumber.cell_phone,
    birthday: Faker::Date.birthday,
    price_per_hour: Money.new(Faker::Number.within(range: 500..10_000), 'HUF'),
    about: Faker::Movies::StarWars.quote,
    password: Faker::Internet.password,
    email: Faker::Internet.email,
    user_roles: UserRole.where(slug: ['user', 'executor']),
    sex: rand >= 0.5 ? :male : :female,
    )
  u.skip_confirmation!
  u.user_verification.confirm_phone
  u.user_verification.confirm_id if rand >= 0.5

  a = DefaultAvatar::Generator.new("#{u.name[0]}#{u.lastname[0]}")
  u.create_photo do |photo|
    photo.file = a.draw
    a.clean
  end
  u.save
  u
end
