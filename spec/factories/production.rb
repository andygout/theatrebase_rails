FactoryGirl.define do

  factory :production do
    title 'Hamlet'
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
