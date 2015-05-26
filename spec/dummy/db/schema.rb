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

ActiveRecord::Schema.define(version: 20131120084440) do

  create_table "content_attributes", force: :cascade do |t|
    t.integer  "content_node_id", null: false
    t.string   "key",             null: false
    t.string   "type",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_attributes", ["content_node_id"], name: "index_content_attributes_on_content_node_id"
  add_index "content_attributes", ["key"], name: "index_content_attributes_on_key"

  create_table "content_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "keywords"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_categories", ["name"], name: "index_content_categories_on_name"

  create_table "content_category_nodes", force: :cascade do |t|
    t.integer "content_node_id"
    t.integer "content_category_id"
  end

  add_index "content_category_nodes", ["content_category_id"], name: "index_content_category_nodes_on_content_category_id"
  add_index "content_category_nodes", ["content_node_id"], name: "index_content_category_nodes_on_content_node_id"

  create_table "content_images", force: :cascade do |t|
    t.string   "caption"
    t.string   "alt"
    t.string   "tags"
    t.string   "text"
    t.string   "url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_node_connections", id: false, force: :cascade do |t|
    t.integer "content_node_id_1", null: false
    t.integer "content_node_id_2", null: false
  end

  add_index "content_node_connections", ["content_node_id_1"], name: "index_content_node_connections_on_content_node_id_1"
  add_index "content_node_connections", ["content_node_id_2"], name: "index_content_node_connections_on_content_node_id_2"

  create_table "content_nodes", force: :cascade do |t|
    t.integer  "parent_id"
    t.integer  "position"
    t.string   "type",                            null: false
    t.string   "title",                           null: false
    t.string   "name",                            null: false
    t.string   "template"
    t.string   "redirect"
    t.string   "url"
    t.string   "keywords"
    t.string   "description"
    t.string   "page_title"
    t.string   "access",      default: "private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "content_nodes", ["name"], name: "index_content_nodes_on_name"
  add_index "content_nodes", ["parent_id"], name: "index_content_nodes_on_parent_id"
  add_index "content_nodes", ["position"], name: "index_content_nodes_on_position"
  add_index "content_nodes", ["title"], name: "index_content_nodes_on_title"
  add_index "content_nodes", ["url"], name: "index_content_nodes_on_url"

  create_table "content_value_datetime", force: :cascade do |t|
    t.integer  "content_attribute_id", null: false
    t.datetime "value",                null: false
  end

  add_index "content_value_datetime", ["content_attribute_id"], name: "index_content_value_datetime_on_content_attribute_id"

  create_table "content_value_float", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.float   "value",                null: false
  end

  add_index "content_value_float", ["content_attribute_id"], name: "index_content_value_float_on_content_attribute_id"

  create_table "content_value_integer", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.integer "value",                null: false
  end

  add_index "content_value_integer", ["content_attribute_id"], name: "index_content_value_integer_on_content_attribute_id"

  create_table "content_value_reference", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.integer "value",                null: false
    t.string  "scope",                null: false
  end

  add_index "content_value_reference", ["content_attribute_id"], name: "index_content_value_reference_on_content_attribute_id"

  create_table "content_value_string", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.string  "value",                null: false
  end

  add_index "content_value_string", ["content_attribute_id"], name: "index_content_value_string_on_content_attribute_id"

  create_table "content_value_text", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.text    "value",                null: false
  end

  add_index "content_value_text", ["content_attribute_id"], name: "index_content_value_text_on_content_attribute_id"

end
