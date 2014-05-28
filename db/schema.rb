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

ActiveRecord::Schema.define(version: 20140527130338) do

  create_table "asset_types", force: true do |t|
    t.string   "name",                              null: false
    t.string   "identifier_type",                   null: false
    t.boolean  "has_sample_number", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", force: true do |t|
    t.string   "identifier",                null: false
    t.integer  "asset_type_id",             null: false
    t.integer  "workflow_id",               null: false
    t.integer  "comment_id",                null: false
    t.integer  "batch_id",                  null: false
    t.string   "study"
    t.integer  "sample_count",  default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
  end

  add_index "assets", ["batch_id"], name: "index_assets_on_batch_id", using: :btree

  create_table "batches", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflows", force: true do |t|
    t.string   "name",                        null: false
    t.boolean  "has_comment", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
