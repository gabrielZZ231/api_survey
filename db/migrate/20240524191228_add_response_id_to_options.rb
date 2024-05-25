class AddResponseIdToOptions < ActiveRecord::Migration[7.1]
  def change
    add_reference :options, :response, foreign_key: true, on_delete: :cascade
  end
end
