user = User.first
theatre = Theatre.find_by_name('Olivier Theatre')

Production.create!( title:        'Hamlet',
                    alphabetise:  nil,
                    url:          'hamlet',
                    first_date:   '07/09/2010',
                    press_date:   '27/10/2010',
                    last_date:    '26/01/2011',
                    theatre:      theatre,
                    creator:      user,
                    updater:      user)
