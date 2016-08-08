user = User.first

Theatre.create!(name:         'Barbican',
                alphabetise:  nil,
                creator:      user,
                updater:      user)
