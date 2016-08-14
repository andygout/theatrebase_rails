user = User.first

Theatre.create!(name:         'Barbican',
                url:          'barbican',
                alphabetise:  nil,
                creator:      user,
                updater:      user)
