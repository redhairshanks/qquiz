class CreateQuizs < ActiveRecord::Migration[7.0]
  def change
    create_table :quizs, id: :uuid do |t|
      t.string :name
      t.integer :time_limit_in_seconds
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
