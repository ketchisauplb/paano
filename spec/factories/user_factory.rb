FactoryGirl.define do
  factory :user
  factory :user_facebook, :parent => :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}" }
    sequence(:name) { |n| "User_#{n}" }
    email
    password Devise.friendly_token[0,20]
  end
end
