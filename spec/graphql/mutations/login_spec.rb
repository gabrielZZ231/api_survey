require 'rails_helper'

RSpec.describe 'Login', type: :request do
  let(:user) { create(:user, email: 'user@example.com', password: '123456') }

  it 'successfully generates a valid JWT on login' do
    post '/graphql', params: { query: login_query(user.email, user.password) }
    json_response = JSON.parse(response.body)
    token = json_response['data']['login']['token']
    expect { token }.not_to raise_error
  end

  it 'fails to login with an invalid' do
    post '/graphql', params: { query: login_query(user.email, 'wrong_password') }
    json_response = JSON.parse(response.body)
    expect(json_response['errors']).to be_present
  end

  def login_query(email, password)
    <<~GQL
      mutation {
        login(input:{email: "#{email}", password: "#{password}"}) {
          token
          errors
        }
      }
    GQL
  end
end
