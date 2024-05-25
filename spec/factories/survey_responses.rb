FactoryBot.define do
  factory :survey_response do
    user_id { create(:user).id }
    survey_id { create(:survey).id }
    response_date { Faker::Time.between(from: 1.year.ago, to: Time.zone.now) }
  end
end
