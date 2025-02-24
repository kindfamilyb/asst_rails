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

ActiveRecord::Schema[7.2].define(version: 2025_02_10_104916) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", primary_key: "api_key_id", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "사용자아이디"
    t.string "access_key", comment: "엑세스키"
    t.string "secret_key", comment: "시크릿키"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "platform", comment: "api_key가 사용되는 플랫폼"
    t.string "app_key", comment: "api_key"
    t.string "api_secret", comment: "api_secret"
    t.string "account_number", comment: "계좌번호"
    t.string "account_code", comment: "계좌코드"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "base_currency"
    t.string "target_currency"
    t.date "date"
    t.decimal "open"
    t.decimal "high"
    t.decimal "low"
    t.decimal "close"
    t.integer "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_buy_routine_strategy_infos", force: :cascade do |t|
    t.string "user_id", comment: "유저 아이디"
    t.string "buy_type", comment: "매수주기타입week:주,month:월,year:년"
    t.string "day_of_week", comment: "요일"
    t.string "day_of_month", comment: "월 날짜"
    t.string "day_of_year", comment: "년 날짜"
    t.integer "strategy_id", comment: "전략 아이디"
    t.string "active_yn", comment: "활성화 여부"
    t.integer "hour", comment: "시간"
    t.integer "minute", comment: "분"
    t.integer "buy_won_cash_account", comment: "매수 원화 계좌량"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "my_strategy_infos", primary_key: "my_strategy_info_id", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "사용자아이디"
    t.integer "signal_number", comment: "신호숫자"
    t.integer "strategy_id", null: false, comment: "전략아이디"
    t.string "active_yn", default: "Y", null: false, comment: "활성여부"
    t.string "delete_yn", default: "N", null: false, comment: "삭제여부"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "target_profit_rate", comment: "목표 매매수익율"
    t.integer "trade_account_rate", comment: "매매 계좌 비율"
    t.integer "trade_delay_duration", comment: "매매 지연 시간"
    t.string "trade_type", comment: "매매 타입"
    t.string "asst_name", comment: "매매 자산이름"
    t.string "trade_delay_type", comment: "매매지연 단위 주월년"
  end

  create_table "posts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "part_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "strategies", primary_key: "strategy_id", force: :cascade do |t|
    t.string "description", default: "*", null: false, comment: "전략설명"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", comment: "전략명"
    t.string "platform"
    t.string "strategy_type"
  end

  create_table "trades", primary_key: "trade_id", force: :cascade do |t|
    t.string "coin_symbol", default: "BTC", null: false
    t.boolean "sold", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", comment: "유저ID"
    t.integer "my_strategy_info_id", comment: "내전략ID"
    t.float "volume", comment: "매도수량"
    t.float "remaining_volume", comment: "남은수량"
    t.float "profit_rate", comment: "수익"
    t.integer "profit", comment: "매도당시수익금"
    t.integer "target_profit_rate", default: 0, comment: "목표수익률"
    t.integer "trade_account_rate", default: 0, comment: "예수금매매비율"
    t.integer "trade_delay_duration", default: 0, comment: "매매대기시간"
  end

  create_table "users", force: :cascade do |t|
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.string "provider"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "logined_yn", default: "N", null: false, comment: "로그인 여부"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end
end
