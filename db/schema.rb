# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_02_20_070715) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "poll_participants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "poll_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "final_score"
    t.index ["poll_id"], name: "index_poll_participants_on_poll_id"
    t.index ["user_id"], name: "index_poll_participants_on_user_id"
  end

  create_table "poll_questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_id", null: false
    t.string "question_text"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_id"], name: "index_poll_questions_on_poll_id"
  end

  create_table "polls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "time_limit_in_seconds"
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_polls_on_user_id"
  end

  create_table "question_answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "poll_question_id", null: false
    t.integer "placement_index"
    t.string "answer_text"
    t.boolean "is_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_question_id"], name: "index_question_answers_on_poll_question_id"
  end

  create_table "user_answers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "poll_question_id", null: false
    t.json "answers"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poll_question_id"], name: "index_user_answers_on_poll_question_id"
    t.index ["user_id"], name: "index_user_answers_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "unique_emails", unique: true
  end

  add_foreign_key "poll_participants", "polls"
  add_foreign_key "poll_participants", "users"
  add_foreign_key "poll_questions", "polls"
  add_foreign_key "polls", "users"
  add_foreign_key "question_answers", "poll_questions"
  add_foreign_key "user_answers", "poll_questions"
  add_foreign_key "user_answers", "users"
end
