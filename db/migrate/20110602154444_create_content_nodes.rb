class CreateContentNodes < ActiveRecord::Migration
  def self.up

    ###
    # nodes
    ###
    create_table :content_nodes do |t|
      t.integer :parent_id
      t.integer :position, null: false
      t.string :type, null: false, size: 30
      t.string :template, null: false, size: 30
      t.string :title, null: false
      t.string :name, null: false
      t.string :access, default: 'private'
      t.string :redirect
      t.string :url
      t.string :meta_keywords # => used to be keywords
      t.string :meta_description # => used to be description
      t.string :meta_title, size: 64 # => used to be page_title
      t.timestamps
    end

    add_index :content_nodes, :parent_id
    add_index :content_nodes, :position
    add_index :content_nodes, :title
    add_index :content_nodes, :name
    add_index :content_nodes, :type

    ###
    # components
    ###
    create_table :content_components do |t|
      t.string :name, null: false
      t.string :type, null: false, size: 30
    end

    add_index :content_components, :type

    create_table :content_components_nodes do |t|
      t.references :content_node
      t.references :content_component
    end

    add_index :content_components_nodes, :content_node_id
    add_index :content_components_nodes, :content_component_id

    ###
    # attributes
    ###
    create_table :content_attributes do |t|
      t.integer :attributable_id, null: false
      t.integer :attributable_type, null: false
      t.string :key, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_index :content_attributes, :attributable_id
    add_index :content_attributes, :attributable_type
    add_index :content_attributes, :key
    add_index :content_attributes, :type

    ###
    # values
    ###
    create_table :content_value_integer do |t|
      t.integer :content_attribute_id, null: false
      t.integer :value, null: false
    end
    add_index :content_value_integer, :content_attribute_id

    create_table :content_value_float do |t|
      t.integer :content_attribute_id, null: false
      t.float :value, null: false
    end
    add_index :content_value_float, :content_attribute_id

    create_table :content_value_string do |t|
      t.integer :content_attribute_id, null: false
      t.string :value, null: false
    end
    add_index :content_value_string, :content_attribute_id

    create_table :content_value_text do |t|
      t.integer :content_attribute_id, null: false
      t.text :value, null: false
    end
    add_index :content_value_text, :content_attribute_id

    create_table :content_value_datetime do |t|
      t.integer :content_attribute_id, null: false
      t.datetime :value, null: false
    end
    add_index :content_value_datetime, :content_attribute_id

    create_table :content_value_reference do |t|
      t.integer :content_attribute_id, null: false
      t.integer :value, null: false
      t.string :scope, null: false
    end
    add_index :content_value_reference, :content_attribute_id

    ###
    # categories
    ###
    create_table :content_categories do |t|
      t.string :name, size: 64
      t.string :description
      t.string :keywords
      t.timestamps
    end

    add_index :content_categories, :name

    create_table :content_categories_nodes do |t|
      t.integer :content_node_id
      t.integer :content_category_id
    end

    add_index :content_categories_nodes, :content_node_id
    add_index :content_categories_nodes, :content_category_id

  end

  def self.down
    drop_table :content_nodes
    drop_table :content_components
    drop_table :content_attributes
    drop_table :content_value_integer
    drop_table :content_value_float
    drop_table :content_value_string
    drop_table :content_value_text
    drop_table :content_value_datetime
    drop_table :content_categories
    drop_table :content_category_nodes
  end

end
