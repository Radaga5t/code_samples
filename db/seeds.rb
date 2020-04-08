# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

I18n.locale = :ru

require Rails.root.join('db/seeds/user_roles')
require Rails.root.join('db/seeds/users')
require Rails.root.join('db/seeds/categories')
require Rails.root.join('db/seeds/languages')
require Rails.root.join('db/seeds/services')
require Rails.root.join('db/seeds/promocodes')
require Rails.root.join('db/seeds/suggestions')
require Rails.root.join('db/seeds/faq')
