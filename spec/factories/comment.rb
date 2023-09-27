FactoryBot.define do
  factory :comment do
    name { FFaker::LoremBR.phrase }
    comment { FFaker::LoremBR.paragraph }
    post
  end
end
