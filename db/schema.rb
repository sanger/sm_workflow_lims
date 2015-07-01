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

ActiveRecord::Schema.define(version: 20150629160352) do

  create_table "asset_types", force: true do |t|
    t.string   "name",                                          null: false
    t.string   "identifier_type",                               null: false
    t.boolean  "has_sample_count",     default: false,          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identifier_data_type", default: "alphanumeric", null: false
  end

  create_table "assets", force: true do |t|
    t.string   "identifier",                          null: false
    t.integer  "asset_type_id",                       null: false
    t.integer  "workflow_id",                         null: false
    t.integer  "comment_id"
    t.integer  "batch_id",                            null: false
    t.string   "study"
    t.integer  "sample_count",            default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.datetime "reported_at"
    t.integer  "pipeline_destination_id"
    t.datetime "begun_at",                            null: false
    t.integer  "cost_code_id"
  end

  add_index "assets", ["asset_type_id"], name: "fk_assets_to_asset_types", using: :btree
  add_index "assets", ["batch_id"], name: "index_assets_on_batch_id", using: :btree
  add_index "assets", ["comment_id"], name: "fk_assets_to_comments", using: :btree
  add_index "assets", ["completed_at"], name: "index_assets_on_completed_at", using: :btree
  add_index "assets", ["identifier"], name: "index_assets_on_identifier", using: :btree
  add_index "assets", ["workflow_id"], name: "fk_assets_to_workflows", using: :btree

  create_table "batches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cost_codes", force: true do |t|
    t.string "name", null: false
  end

  create_table "pipeline_destinations", force: true do |t|
    t.string "name"
  end

  create_table "workflows", force: true do |t|
    t.string   "name",                        null: false
    t.boolean  "has_comment", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "reportable",  default: false, null: false
  end

end
