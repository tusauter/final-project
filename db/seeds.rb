# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

the_users = [{ :email => 'John.Miller@chicagobooth.edu',
  :first_name => 'John',
  :last_name =>'Miller',
  :gender => 'male',
  :account_activated => true
},
{ :email => 'Jane.Miller@chicagobooth.edu',
  :first_name => 'Jane',
  :last_name =>'Miller',
  :gender => 'female',
  :account_activated => true
},
{ :email => 'Jean.Miller@chicagobooth.edu',
  :first_name => 'Jean',
  :last_name =>'Miller',
  :gender => 'female',
  :account_activated => true
},
{ :email => 'Jim.Miller@chicagobooth.edu',
  :first_name => 'Jim',
  :last_name =>'Miller',
  :gender => 'male',
  :account_activated => true
},
{ :email => 'David.Miller@chicagobooth.edu',
  :first_name => 'David',
  :last_name =>'Miller',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Michael.Miller@chicagobooth.edu',
  :first_name => 'Michael',
  :last_name =>'Miller',
  :gender => 'male',
  :account_activated => true
},
{ :email => 'Tracy.Miller@chicagobooth.edu',
  :first_name => 'Tracy',
  :last_name =>'Miller',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Sarah.Miller@chicagobooth.edu',
  :first_name => 'Sarah',
  :last_name =>'Miller',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Sarah.Smith@dukefuqua.edu',
  :first_name => 'Sarah',
  :last_name =>'Smith',
  :gender => 'female',
  :account_activated => true
},
{ :email => 'Jonathan.Jacobson@dukefuqua.edu',
  :first_name => 'Jonathan',
  :last_name =>'Jacobson',
  :gender => 'male',
  :account_activated => true
},
{ :email => 'Jessica.Scott@dukefuqua.edu',
  :first_name => 'Jessica',
  :last_name =>'Scott',
  :gender => 'female',
  :account_activated => true
},
{ :email => 'Manny.Michaels@dukefuqua.edu',
  :first_name => 'Manny',
  :last_name =>'Michaels',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Frederick.Clark@dukefuqua.edu',
  :first_name => 'Frederick',
  :last_name =>'Clark',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Sam.Smith@haas.edu',
  :first_name => 'Sam',
  :last_name =>'Smith',
  :gender => 'male',
  :account_activated => true
},
{ :email => 'Clark.Joseph@haas.edu',
  :first_name => 'Clark',
  :last_name =>'Joseph',
  :gender => nil,
  :account_activated => true
},
{ :email => 'Heather.Thompson@haas.edu',
  :first_name => 'Heather',
  :last_name => 'Thompson',
  :gender =>'female',
  :account_activated => true
}]

the_users.each do |new_user|
  u = User.new(new_user)
  u.salt = BCrypt::Engine.generate_salt
  u.password_hash = BCrypt::Engine.hash_secret 'password', u.salt
  u.save
end