Response.delete_all
Option.delete_all
Question.delete_all
SurveyResponse.delete_all
Survey.delete_all

users = User.all

10.times do
    user = users.sample
  
    survey = Survey.create!(
      title: Faker::Lorem.sentence(word_count: 3),
      user: user,
      finished: [true, false].sample
    )
  
    survey_response = SurveyResponse.create!(
      user: user,
      survey: survey,
      response_date: Faker::Date.between(from: '2022-01-01', to: '2024-12-31')
    )
  
    3.times do
        question = Question.create!(
          content: Faker::Lorem.question(word_count: 4),
          question_type: ['text', 'multiple_choice', 'single_choice'].sample,
          survey: survey
        )
        
        response = Response.create!(
            content: Faker::Lorem.sentence(word_count: 3),
            question: question,
            survey_response: survey_response,
            survey: survey,  
            user: user
          )
          

  
      4.times do
        Option.create!(
          content: Faker::Lorem.sentence(word_count: 2),
          question: question,
          response: response
        )
      end
    end
  end
  