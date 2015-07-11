require 'faker'

70.times do 
  user = User.new(name: Faker::Name.name, email: Faker::Internet.email, password: Faker::Internet.password(8)) 
  user.skip_confirmation! 
  user.save!
end 
users = User.all 


  600.times do 
    creator = (users.sample)
    wiki = Wiki.new(title: Faker::Lorem.sentence, body: Faker::Lorem.paragraphs(3), user_id: creator.id, private: false) 
    wiki.users << users.sample << creator 
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
 admin.save 
end 

 

 puts "#{users.count} users created" 

 puts "#{wikis.count} wikis created" 

 puts "That was a fucking helluva lotta seeds to spray about, bro!!"

#**********************************************



# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
