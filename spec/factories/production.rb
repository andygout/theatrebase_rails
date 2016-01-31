FactoryGirl.define do

  factory :production do
    title 'Hamlet'

    factory :add_production do
      title 'Othello'
    end

    factory :edit_production do
      title 'Macbeth'
    end
  end

end
