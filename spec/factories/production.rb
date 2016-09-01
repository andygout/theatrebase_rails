FactoryGirl.define do

  factory :production do
    sequence(:title)    { |n| "Production #{n}" }
    sequence(:url)      { |n| "production-#{n}" }
    first_date          '05/08/2015'
    last_date           '31/10/2015'
    dates_info          3
    press_date_wording  'Press day'
    dates_tbc_note      'Summer 2015'
    dates_note          'Press day postponed'
    association         :theatre
    association         :creator, factory: :user
    updater             { creator }
  end

end
