class RemoveTypeFromPollQuestions < ActiveRecord::Migration[7.0]
  def change
    remove_column :poll_questions, :type
  end
end
