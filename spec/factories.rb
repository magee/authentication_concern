FactoryGirl.define do
  sequence(:email)    { |i| "email_#{i}@example.com" }
  sequence(:username) { |i| "user_#{i}" }

  factory :user do
    username
    email
    password "password"
  end
end
