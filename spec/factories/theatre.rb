FactoryGirl.define do

  factory :theatre do
    name        'Barbican'
    url         'barbican'
    association :creator, factory: :third_user
    updater     { creator }

    factory :add_theatre do
      name  'Almeida Theatre'
    end
  end

end
