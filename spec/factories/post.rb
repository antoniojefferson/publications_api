FactoryBot.define do
  factory :post do
    title { FFaker::LoremBR.phrase }
    text { FFaker::LoremBR.paragraph }
    user
  end
end
