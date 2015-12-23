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

    factory :admin_user do
      name  'David Jones'
      email 'davidjones@example.com'
      admin
    end

    factory :second_admin_user do
      name  'Charlie Brown'
      email 'charliebrown@example.com'
      admin
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
