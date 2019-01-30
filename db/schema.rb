# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190130131354) do

  create_table "asset_types", force: :cascade do |t|
    t.string   "name",                 limit: 255,                          null: false
    t.string   "identifier_type",      limit: 255,                          null: false
    t.boolean  "has_sample_count",                 default: false,          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier_data_type", limit: 255, default: "alphanumeric", null: false
  end

  create_table "assets", force: :cascade do |t|
    t.string   "identifier",              limit: 255,             null: false
    t.integer  "asset_type_id",           limit: 4,               null: false
    t.integer  "workflow_id",             limit: 4,               null: false
    t.integer  "comment_id",              limit: 4
    t.integer  "batch_id",                limit: 4,               null: false
    t.string   "study",                   limit: 255
    t.integer  "sample_count",            limit: 4,   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.datetime "reported_at"
    t.integer  "pipeline_destination_id", limit: 4
    t.datetime "begun_at",                                        null: false
    t.integer  "cost_code_id",            limit: 4
    t.string   "project",                 limit: 255
  end

  add_index "assets", ["asset_type_id"], name: "index_assets_on_asset_type_id", using: :btree
  add_index "assets", ["batch_id"], name: "index_assets_on_batch_id", using: :btree
  add_index "assets", ["comment_id"], name: "index_assets_on_comment_id", using: :btree
  add_index "assets", ["identifier"], name: "index_assets_on_identifier", using: :btree
  add_index "assets", ["workflow_id"], name: "index_assets_on_workflow_id", using: :btree

  create_table "batches", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cost_codes", force: :cascade do |t|
    t.string "name", limit: 255, null: false
  end

  create_table "events", force: :cascade do |t|
    t.integer  "asset_id",   limit: 4, null: false
    t.integer  "state_id",   limit: 4, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pipeline_destinations", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "states", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflows", force: :cascade do |t|
    t.string   "name",             limit: 255,                 null: false
    t.boolean  "has_comment",                  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reportable",                   default: false, null: false
    t.integer  "turn_around_days", limit: 4
    t.integer  "initial_state_id", limit: 4
    t.boolean  "active",                       default: true,  null: false
  end

  add_index "workflows", ["initial_state_id"], name: "index_workflows_on_initial_state_id", using: :btree

  add_foreign_key "assets", "asset_types"
  add_foreign_key "assets", "batches"
  add_foreign_key "assets", "comments"
  add_foreign_key "assets", "workflows"
end
