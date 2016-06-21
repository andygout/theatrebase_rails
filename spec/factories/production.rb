FactoryGirl.define do

  factory :production do
    title       'Hamlet'
    url         'hamlet'
    first_date  '05/08/2015'
    last_date   '31/10/2015'
    association :creator, factory: :second_user
    updater     { creator }

    factory :add_production do
      title               'Othello'
      press_date_wording  'Press day'
      dates_tbc_note      'Jan 2016'
      dates_note          'Press day postponed'
    end
  end

end
