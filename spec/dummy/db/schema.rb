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

ActiveRecord::Schema.define(version: 2018_10_24_113050) do

  create_table "content_attributes", force: :cascade do |t|
    t.integer "attributable_id", null: false
    t.string "attributable_type", null: false
    t.string "key", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attributable_id", "attributable_type"], name: "index_content_attributes_on_attr_id_and_attr_type"
    t.index ["key"], name: "index_content_attributes_on_key"
    t.index ["type"], name: "index_content_attributes_on_type"
  end

  create_table "content_categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_content_categories_on_name"
  end

  create_table "content_categories_nodes", force: :cascade do |t|
    t.integer "content_node_id"
    t.integer "content_category_id"
    t.index ["content_category_id"], name: "index_content_categories_nodes_on_content_category_id"
    t.index ["content_node_id"], name: "index_content_categories_nodes_on_content_node_id"
  end

  create_table "content_components", force: :cascade do |t|
    t.integer "componentable_id", null: false
    t.string "componentable_type", null: false
    t.integer "position", null: false
    t.string "type", null: false
    t.string "template", null: false
    t.index ["componentable_id", "componentable_type"], name: "index_content_components_on_compo_id_and_compo_type"
    t.index ["position"], name: "index_content_components_on_position"
    t.index ["type"], name: "index_content_components_on_type"
  end

  create_table "content_documents", force: :cascade do |t|
    t.string "name", null: false
    t.string "tags"
    t.string "attachment_file_name", null: false
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "content_images", force: :cascade do |t|
    t.string "tags"
    t.text "caption"
    t.string "url"
    t.string "alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_uid"
    t.string "image_name"
    t.integer "image_width"
    t.integer "image_height"
    t.string "copyright"
  end

  create_table "content_node_connections", id: false, force: :cascade do |t|
    t.integer "content_node_id_1", null: false
    t.integer "content_node_id_2", null: false
    t.index ["content_node_id_1"], name: "index_content_node_connections_on_content_node_id_1"
    t.index ["content_node_id_2"], name: "index_content_node_connections_on_content_node_id_2"
  end

  create_table "content_nodes", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "position", null: false
    t.string "type", null: false
    t.string "template", null: false
    t.string "title", null: false
    t.string "name", null: false
    t.string "access", default: "private"
    t.string "redirect"
    t.string "url"
    t.string "meta_keywords"
    t.string "meta_description"
    t.string "meta_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "meta_noindex"
    t.index ["access"], name: "index_content_nodes_on_access"
    t.index ["name"], name: "index_content_nodes_on_name"
    t.index ["parent_id"], name: "index_content_nodes_on_parent_id"
    t.index ["position"], name: "index_content_nodes_on_position"
    t.index ["title"], name: "index_content_nodes_on_title"
    t.index ["type"], name: "index_content_nodes_on_type"
  end

  create_table "content_value_boolean", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.boolean "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_boolean_on_content_attribute_id"
  end

  create_table "content_value_datetime", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.datetime "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_datetime_on_content_attribute_id"
  end

  create_table "content_value_float", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.float "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_float_on_content_attribute_id"
  end

  create_table "content_value_integer", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.integer "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_integer_on_content_attribute_id"
  end

  create_table "content_value_reference", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.integer "value", null: false
    t.string "reference_type", null: false
    t.index ["content_attribute_id"], name: "index_content_value_reference_on_content_attribute_id"
    t.index ["reference_type", "value"], name: "index_content_value_reference_on_reference_type_and_value"
  end

  create_table "content_value_string", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.string "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_string_on_content_attribute_id"
  end

  create_table "content_value_text", force: :cascade do |t|
    t.integer "content_attribute_id", null: false
    t.text "value", null: false
    t.index ["content_attribute_id"], name: "index_content_value_text_on_content_attribute_id"
  end

end
