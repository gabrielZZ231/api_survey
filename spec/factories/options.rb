  FactoryBot.define do
    factory :option do
      content { Faker::Lorem.sentence }
      question_id { create(:question).id }
    end
  end
