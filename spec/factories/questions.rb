FactoryBot.define do
  factory :question do
    content { Faker::Lorem.sentence }
    survey_id { create(:survey).id }
    question_type { ['multiple_choice', 'open_ended'].sample }
  end
end
