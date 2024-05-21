class AddFinishedToSurveys < ActiveRecord::Migration[7.1]
  def change
    add_column :surveys, :finished, :boolean
  end
end
