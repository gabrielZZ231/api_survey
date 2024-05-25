FactoryBot.define do
  factory :survey do
    title { Faker::Lorem.sentence }
    user_id { create(:user).id }
    finished { [true, false].sample }
  end
end
