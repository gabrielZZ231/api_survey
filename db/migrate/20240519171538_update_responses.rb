class UpdateResponses < ActiveRecord::Migration[7.1]
  def change
    remove_reference :responses, :user, index: true, foreign_key: true
    remove_reference :responses, :survey, index: true, foreign_key: true
    add_reference :responses, :survey_response, foreign_key: true
  end
end
