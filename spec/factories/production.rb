FactoryGirl.define do

  factory :production do
    title 'Hamlet'
    first_date '05/08/2015'
    last_date  '31/10/2015'
    association :creator, factory: :second_user
    updater { creator }

    factory :add_production do
      title 'Othello'
    end

    factory :edit_production do
      title 'Macbeth'
    end
  end

end
