FactoryGirl.define do

  factory :user do
    sequence(:name)     { |n| "User #{n}" }
    sequence(:email)    { |n| "user#{n}@example.com" }
    sequence(:password) { |n| "password#{n}" }
    activated_at        { Time.zone.now }

    factory :created_user do
      association :creator, factory: :user
      updater { creator }
    end

    factory :unactivated_user do
      activated_at  nil
    end

    factory :invalid_user do
      name  ''
      email 'user@example'
    end

    factory :suspended_user do
      after(:create) do |user|
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_user do
      after(:create) do |user|
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :super_admin_user do
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :second_super_admin_user do
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :assignor_super_admin_user do
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
      end
    end

    factory :suspended_super_admin_user do
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_super_admin_user do
      after(:create) do |user|
        create(:super_admin, user_id: user.id)
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :admin_user do
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_admin_user do
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :suspended_admin_user do
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end

    factory :second_suspended_admin_user do
      after(:create) do |user|
        create(:admin, user_id: user.id, assignor: create(:assignor_super_admin_user))
        create(:suspension, user_id: user.id, assignor: create(:assignor_super_admin_user))
      end
    end
  end

end
