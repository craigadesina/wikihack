require 'faker'


90.times do
  user = User.new(name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(8))
  user.skip_confirmation!
  user.save!
end
users = User.all


  500.times do
    wiki = users.sample.wikis.new(title: Faker::Lorem.words, body: Faker::Lorem.sentence)
    wiki.save!
  end
  wikis = Wiki.all

# Create an default user
 if !User.find_by(email: 'admin@example.com')
 admin = User.new(
   name:     'Admin User',
   email:    'admin@example.com',
   password: 'helloworld',
   )
 admin.skip_confirmation!
 admin.save!
end

 

 puts "#{users.count} users created"

 puts "#{wikis.count} wikis created"

 puts "That was a fucking helluva lotta seeds to spray about, bro!!"

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
