class CreateQuestionAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :question_answers, id: :uuid do |t|
      t.belongs_to :poll_question, null: false, foreign_key: true, type: :uuid
      t.integer :placement_index
      t.string :answer_text
      t.boolean :is_answer
      t.timestamps
    end
  end
end
