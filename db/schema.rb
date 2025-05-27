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

ActiveRecord::Schema[7.1].define(version: 2025_05_27_004530) do
  create_table "active_storage_attachments", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb3", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bloom_reports", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false, comment: "投稿者"
    t.bigint "flower_spot_id", null: false, comment: "花スポット"
    t.string "title", null: false, comment: "投稿タイトル"
    t.text "description", comment: "投稿内容"
    t.integer "bloom_status", default: 0, comment: "開花状況（0:つぼみ, 1:咲き始め, 2:見頃, 3:散り始め, 4:終了）"
    t.integer "view_count", default: 0, comment: "閲覧数"
    t.integer "likes_count", default: 0, comment: "いいね数"
    t.integer "status", default: 0, comment: "承認状況（0:審査中, 1:承認済み, 2:却下）"
    t.datetime "reported_at", null: false, comment: "報告日時"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flower_spot_id", "reported_at"], name: "index_bloom_reports_on_flower_spot_id_and_reported_at"
    t.index ["flower_spot_id"], name: "index_bloom_reports_on_flower_spot_id"
    t.index ["likes_count"], name: "index_bloom_reports_on_likes_count"
    t.index ["reported_at"], name: "index_bloom_reports_on_reported_at"
    t.index ["status"], name: "index_bloom_reports_on_status"
    t.index ["user_id"], name: "index_bloom_reports_on_user_id"
    t.index ["view_count"], name: "index_bloom_reports_on_view_count"
  end

  create_table "flower_spots", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "flower_id", null: false
    t.bigint "mountain_id", null: false
    t.string "best_viewing_time", comment: "最適な観賞時期"
    t.text "notes", comment: "備考"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flower_id", "mountain_id"], name: "index_flower_spots_on_flower_id_and_mountain_id", unique: true
    t.index ["flower_id"], name: "index_flower_spots_on_flower_id"
    t.index ["mountain_id"], name: "index_flower_spots_on_mountain_id"
  end

  create_table "flowers", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false, comment: "花名"
    t.string "scientific_name", comment: "学名"
    t.text "description", comment: "説明"
    t.string "color", comment: "花の色"
    t.string "size", comment: "花のサイズ"
    t.string "habitat", comment: "生息環境"
    t.integer "bloom_start_month", null: false, comment: "開花開始月"
    t.integer "bloom_end_month", null: false, comment: "開花終了月"
    t.integer "peak_month", comment: "開花ピーク月"
    t.integer "altitude_min", comment: "最低標高"
    t.integer "altitude_max", comment: "最高標高"
    t.integer "difficulty_level", default: 0, comment: "難易度（0:初級, 1:中級, 2:上級）"
    t.string "image_url", comment: "画像URL"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bloom_end_month"], name: "index_flowers_on_bloom_end_month"
    t.index ["bloom_start_month"], name: "index_flowers_on_bloom_start_month"
    t.index ["difficulty_level"], name: "index_flowers_on_difficulty_level"
    t.index ["name"], name: "index_flowers_on_name"
  end

  create_table "likes", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "bloom_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bloom_report_id"], name: "index_likes_on_bloom_report_id"
    t.index ["user_id", "bloom_report_id"], name: "index_likes_on_user_id_and_bloom_report_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "mountains", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false, comment: "山名"
    t.integer "elevation", comment: "標高（メートル）"
    t.decimal "latitude", precision: 10, scale: 6, comment: "緯度"
    t.decimal "longitude", precision: 10, scale: 6, comment: "経度"
    t.bigint "region_id", null: false, comment: "地域ID"
    t.string "prefecture", comment: "都道府県"
    t.text "description", comment: "説明"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["elevation"], name: "index_mountains_on_elevation"
    t.index ["latitude", "longitude"], name: "index_mountains_on_latitude_and_longitude"
    t.index ["name"], name: "index_mountains_on_name"
    t.index ["prefecture"], name: "index_mountains_on_prefecture"
    t.index ["region_id"], name: "index_mountains_on_region_id"
  end

  create_table "regions", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false, comment: "地域名（例：北海道）"
    t.string "code", null: false, comment: "地域コード（例：HOKKAIDO）"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_regions_on_code", unique: true
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "last_name_kana", null: false
    t.string "first_name_kana", null: false
    t.string "nickname", null: false
    t.date "birth_date", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bloom_reports", "flower_spots"
  add_foreign_key "bloom_reports", "users"
  add_foreign_key "flower_spots", "flowers"
  add_foreign_key "flower_spots", "mountains"
  add_foreign_key "likes", "bloom_reports"
  add_foreign_key "likes", "users"
  add_foreign_key "mountains", "regions"
end
