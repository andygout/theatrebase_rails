FactoryGirl.define do

  factory :user do
    name          'Andy Gout'
    email         'andygout@example.com'
    password      'foobar'
    activated_at  { Time.zone.now }

    factory :second_user do
      name  'John Smith'
      email 'johnsmith@example.com'
    end

    factory :third_user do
      name  'Fred White'
      email 'fredwhite@example.com'
    end

    factory :created_user do
      name  'Jack Fraser'
      email 'jackfraser@example.com'
      association :creator, factory: :user
      updater { creator }
    end

    factory :unactivated_user do
      name          'Ted Barnes'
      email         'tedbarnes@example.com'
      activated_at  nil
    end

    factory :suspended_user do
      name  'Charles Vincent'
      email 'charlesvincent@example.com'
      after(:create) do |user|
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_user do
      name  'Anthony Croft'
      email 'anthonycroft@example.com'
      after(:create) do |user|
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
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

    factory :assignor_super_admin_user do
      name  'Kenneth Murphy'
      email { ('a'..'z').to_a.shuffle.join + '@example.com' }
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :suspended_super_admin_user do
      name  'Mark Wilson'
      email 'markwilson@example.com'
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_super_admin_user do
      name  'Kurt Hyslop'
      email 'kurthyslop@example.com'
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :admin_user do
      name  'David Jones'
      email 'davidjones@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_admin_user do
      name  'Charlie Brown'
      email 'charliebrown@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :suspended_admin_user do
      name  'Christian Donaldson'
      email 'christiandonaldson@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_admin_user do
      name  'Terence Johnson'
      email 'terencejohnson@example.com'
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
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
