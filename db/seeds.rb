# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
#
# Create a main sample user
User.create!(name: 'Andrei',
             email: 'andreisofei2002@gmail.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
# Create not activated user
User.create!(name: 'Adrian',
             email: 'andrei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: false,
             activated: false)
# Create not admin user but activated
User.create!(name: 'Luminita',
             email: 'luminitasofei@yahoo.com',
             password: 'delungime8',
             password_confirmation: 'delungime8',
             admin: false,
             activated: true)
# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example#{n+1}@yahoo.com"
  password = "delungime8"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               admin: false,
               activated: true,
               activated_at: Time.zone.now)
end

# Generate microposts for a subset of users
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count: 2)
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(title: title, content: content) }
end

# Create follwing relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each do |followed|
  user.follow(followed)
end
followers.each do |follower|
  follower.follow(user)
end
