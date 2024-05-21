class ChangeSurveyResponseIdNullToResponses < ActiveRecord::Migration[7.1]
  def up
    change_column :responses, :survey_response_id, :integer, null: false
  end

  def down
    change_column :responses, :survey_response_id, :integer, null: true
  end
end