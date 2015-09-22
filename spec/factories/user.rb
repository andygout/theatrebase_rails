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
  end

end