user = User.create!(name:                   'Andy Gout',
                    email:                  'andygout@example.com',
                    password:               'foobar',
                    password_confirmation:  'foobar',
                    activated_at:           Time.zone.now
                   )

99.times do |n|
  User.create!( name:                   Faker::Name.name,
                email:                  "user#{n+1}@example.com",
                password:               'password',
                password_confirmation:  'password',
                activated_at:           Time.zone.now,
                creator:                user,
                updater:                user
              )
end

SuperAdmin.create!(user: user)

production = Production.new
Production.create!( title:        'Hamlet',
                    alphabetise:  production.get_alphabetise_value('Hamlet'),
                    url:          production.generate_url('Hamlet'),
                    first_date:   '05/08/2015',
                    press_date:   '25/08/2015',
                    last_date:    '31/10/2015',
                    creator:      user,
                    updater:      user)
