FactoryGirl.define do

  factory :user do
    name          'Andy Gout'
    email         'andygout@example.com'
    password      'foobar'
    activated     true
    activated_at  { Time.zone.now }

    factory :second_user do
      name  'John Smith'
      email 'johnsmith@example.com'
    end

    factory :third_user do
      name  'Fred White'
      email 'fredwhite@example.com'
    end

    factory :super_admin_user do
      name  'Daniel Taylor'
      email 'danieltaylor@example.com'
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :second_super_admin_user do
      name  'Harry Williams'
      email 'harrywilliams@example.com'
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :admin_user do
      name  'David Jones'
      email 'davidjones@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id)
      end
    end

    factory :second_admin_user do
      name  'Charlie Brown'
      email 'charliebrown@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id)
      end
    end

    factory :list_users do
      sequence(:name)   { |n| "User #{n}" }
      sequence(:email)  { |n| "user#{n}@example.com" }
    end

    factory :edit_user do
      name      'Andrew Gout'
      email     'andrewgout@example.com'
      password  'barfoo'
    end

    factory :invalid_user do
      name  ''
      email 'andygout@example'
    end
  end

end
