class CreatePollQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :poll_questions, id: :uuid do |t|
      t.belongs_to :poll, null: false, foreign_key: true, type: :uuid
      t.string :question_text
      t.integer :points
      t.string :type
      t.timestamps
    end
  end
end
