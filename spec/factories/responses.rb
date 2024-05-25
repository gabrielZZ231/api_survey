FactoryBot.define do
  factory :response do
    content { Faker::Lorem.sentence }
    user_id { create(:user).id }
    question_id { create(:question).id }
    survey_id { create(:survey).id }
    survey_response_id { create(:survey_response).id }
    options { [create(:option)] }
  end
end
