class CreateUserAnswers < ActiveRecord::Migration[7.0]
  def change
    create_table :user_answers, id: :uuid do |t|
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.belongs_to :poll_question, null: false, foreign_key: true, type: :uuid
      t.json :answers
      t.integer :score
      t.timestamps
    end
  end
end
