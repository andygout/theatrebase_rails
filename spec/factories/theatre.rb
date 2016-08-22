FactoryGirl.define do

  factory :theatre do
    sequence(:name) { |n| "Theatre #{n}" }
    sequence(:url)  { |n| "theatre-#{n}" }
    association     :creator, factory: :user
    updater         { creator }
  end

end
