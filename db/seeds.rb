10.times do
  User.create!(
  email: Faker::Internet.email,
  password: Faker::Internet.password,
  confirmed_at: Faker::Time.between(DateTime.now - 1, DateTime.now)
  )
end

users = User.all

50.times do
  Wiki.create!(
  title: Faker::Hipster.sentence,
  body: Faker::Hipster.paragraph,
  user: users.sample,
  private: false
  )
end

User.create!(
  email: 'admin@admin.com',
  password: 'helloworld',
  role: 'admin',
  confirmed_at: "2016-07-13 20:00:00"
)

User.create!(
  email: 'standard@standard.com',
  password: 'helloworld',
  role: 'standard',
  confirmed_at: "2016-07-13 20:00:00"
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"