user = User.create!(name:                   'Andy Gout',
                    email:                  'andygout@example.com',
                    password:               'foobar',
                    password_confirmation:  'foobar'
                   )

99.times do |n|
  User.create!( name:                   Faker::Name.name,
                email:                  "user#{n+1}@example.com",
                password:               'password',
                password_confirmation:  'password'
              )
end

Admin.create!(user_id: user.id)