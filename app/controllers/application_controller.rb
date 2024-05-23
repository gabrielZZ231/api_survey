class ApplicationController < ActionController::API

    def current_user
        token = request.headers['Authorization']
        return unless token

        decoded_token = JWT.decode(token, 'my_secret', true, algorithm: 'HS256')
        User.find(decoded_token.first['user_id'])
      end

end
