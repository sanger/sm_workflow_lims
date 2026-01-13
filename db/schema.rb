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

ActiveRecord::Schema[7.2].define(version: 2019_09_24_154728) do
  create_table "asset_types", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.string "identifier_type", null: false
    t.boolean "has_sample_count", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "identifier_data_type", default: "alphanumeric", null: false
    t.string "labware_type"
  end

  create_table "assets", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "identifier", null: false
    t.integer "asset_type_id", null: false
    t.integer "workflow_id", null: false
    t.integer "comment_id"
    t.integer "batch_id", null: false
    t.string "study"
    t.integer "sample_count", default: 1, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.datetime "completed_at", precision: nil
    t.datetime "reported_at", precision: nil
    t.integer "pipeline_destination_id"
    t.datetime "begun_at", precision: nil, null: false
    t.integer "cost_code_id"
    t.string "project"
    t.index ["asset_type_id"], name: "index_assets_on_asset_type_id"
    t.index ["batch_id"], name: "index_assets_on_batch_id"
    t.index ["comment_id"], name: "index_assets_on_comment_id"
    t.index ["identifier"], name: "index_assets_on_identifier"
    t.index ["workflow_id"], name: "index_assets_on_workflow_id"
  end

  create_table "batches", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "comments", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "cost_codes", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "events", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.integer "asset_id", null: false
    t.integer "state_id", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "pipeline_destinations", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name"
  end

  create_table "states", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "workflows", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "has_comment", default: false, null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "reportable", default: false, null: false
    t.integer "turn_around_days"
    t.integer "initial_state_id"
    t.boolean "active", default: true, null: false
    t.boolean "qc_flow", default: false, null: false
    t.boolean "cherrypick_flow", default: false, null: false
    t.index ["initial_state_id"], name: "index_workflows_on_initial_state_id"
  end

  add_foreign_key "assets", "asset_types"
  add_foreign_key "assets", "batches"
  add_foreign_key "assets", "comments"
  add_foreign_key "assets", "workflows"
end
