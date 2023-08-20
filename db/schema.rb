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

ActiveRecord::Schema[7.0].define(version: 2023_08_19_223312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_favorites_on_team_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "home_score"
    t.integer "away_score"
    t.string "location"
    t.datetime "date"
    t.string "status", default: "upcoming"
    t.bigint "round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tournament_id"
    t.integer "first_previous_game_id"
    t.integer "second_previous_game_id"
    t.index ["round_id"], name: "index_games_on_round_id"
  end

  create_table "lineups", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.bigint "team_id", null: false
    t.string "lineup_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_lineups_on_game_id"
    t.index ["player_id"], name: "index_lineups_on_player_id"
    t.index ["team_id"], name: "index_lineups_on_team_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "position"
    t.integer "shirt_number"
    t.integer "games_played", default: 0, null: false
    t.integer "goals", default: 0, null: false
    t.integer "assists", default: 0, null: false
    t.integer "yellow_cards", default: 0, null: false
    t.integer "red_cards", default: 0, null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "rounds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tournament_id"
  end

  create_table "single_stats", force: :cascade do |t|
    t.integer "game_id"
    t.integer "team_id"
    t.integer "first_player_id"
    t.integer "second_player_id"
    t.integer "minute"
    t.string "stat_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "games_played", default: 0, null: false
    t.integer "wins", default: 0, null: false
    t.integer "draws", default: 0, null: false
    t.integer "defeats", default: 0, null: false
    t.integer "goals_for", default: 0, null: false
    t.integer "goals_against", default: 0, null: false
    t.integer "points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tournament_id"
  end

  create_table "tournament_editors", force: :cascade do |t|
    t.string "tournament_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tournament_editors_on_user_id"
  end

  create_table "tournaments", id: { type: :string, limit: 6, default: -> { "gen_random_uuid()" } }, force: :cascade do |t|
    t.string "name"
    t.string "format"
    t.integer "number_of_teams"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "private", default: false, null: false
    t.integer "creator_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "teams"
  add_foreign_key "favorites", "users"
  add_foreign_key "games", "rounds"
  add_foreign_key "lineups", "games"
  add_foreign_key "lineups", "players"
  add_foreign_key "lineups", "teams"
  add_foreign_key "players", "teams"
  add_foreign_key "tournament_editors", "tournaments"
  add_foreign_key "tournament_editors", "users"
end
