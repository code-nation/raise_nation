# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Deleting Users and Accounts"

AccountUser.delete_all
Account.delete_all
User.delete_all

puts "Generating users..."

5.times { |i|
  user = User.create(email: "testuser#{i}@test.com", password: "P@ssw0rd!", first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
  puts "Populating #{user.email}'s' owned accounts..."
  5.times do
    account = user.owned_accounts.create(organisation_name: Faker::Company.name)
    user.accounts << account
  end
}
