FactoryGirl.define do

  factory :user do
    name 'Andy Gout'
    email 'andygout@example.com'
    password 'foobar'
    password_confirmation 'foobar'

    factory :invalid_user do
      name ''
      email 'andygout@example'
      password 'foo'
      password_confirmation 'bar'
    end

    factory :edit_user do
      name 'Andrew Gout'
      email 'andrewgout@example.com'
      password ''
      password_confirmation ''
    end

    factory :second_user do
      name 'John Smith'
      email 'johnsmith@example.com'
      password 'barfoo'
      password_confirmation 'barfoo'
    end
  end

end