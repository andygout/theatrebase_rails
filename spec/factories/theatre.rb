FactoryGirl.define do

  factory :theatre do
    name        'Barbican'
    url         'barbican'
    association :creator, factory: :third_user
    updater     { creator }

    factory :second_theatre do
      name  'Hampstead Theatre'
      url   'hampstead-theatre'
      association :creator, factory: :super_admin_user
      updater     { creator }
    end

    factory :add_theatre do
      name  'Almeida Theatre'
      url   'almeida-theatre'
    end
  end

end
