user = User.first

theatre = Theatre.create!(name:           'National Theatre',
                          url:            'national-theatre',
                          alphabetise:    nil,
                          sur_theatre:    nil,
                          creator:        user,
                          updater:        user)

[
  { name: 'Olivier Theatre',    url: 'national-theatre-olivier-theatre' },
  { name: 'Lyttelton Theatre',  url: 'national-theatre-lyttelton-theatre' },
  { name: 'Dorfman Theatre',    url: 'national-theatre-dorfman-theatre' }
].each do |sub_theatre|
  Theatre.create!(name:           sub_theatre[:name],
                  url:            sub_theatre[:url],
                  alphabetise:    nil,
                  sur_theatre:    theatre,
                  creator:        user,
                  updater:        user)
end
