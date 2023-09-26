FactoryBot.define do
  factory :user do
    name { FFaker::NameBR.first_name }
    email { FFaker::Internet.email }
    password_digest { FFaker::Internet.password }
  end
end
