user = User.create!(name:                   'Andy Gout',
                    email:                  'andygout@example.com',
                    password:               'foobar',
                    password_confirmation:  'foobar',
                    activated:              true,
                    activated_at:           Time.zone.now
                   )

99.times do |n|
  User.create!( name:                   Faker::Name.name,
                email:                  "user#{n+1}@example.com",
                password:               'password',
                password_confirmation:  'password',
                activated:              true,
                activated_at:           Time.zone.now,
                creator_id:             user.id,
                updater_id:             user.id
              )
end

Admin.create!(user_id: user.id)
