user = User.first

Theatre.create!(name:     'Barbican',
                creator:  user,
                updater:  user)
