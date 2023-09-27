FactoryBot.define do
  factory :user do
    name { FFaker::NameBR.first_name }
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
