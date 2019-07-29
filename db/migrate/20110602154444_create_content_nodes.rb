class CreateContentNodes < ActiveRecord::Migration[5.2]
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
      t.integer :componentable_id, null: false
      t.string :componentable_type, null: false, size: 50
      t.integer :position, null: false
      t.string :type, null: false, size: 30
      t.string :template, null: false, size: 30
    end

    add_index :content_components, [:componentable_id, :componentable_type], name: 'index_content_components_on_compo_id_and_compo_type'
    add_index :content_components, :position
    add_index :content_components, :type

    ###
    # attributes
    ###
    create_table :content_attributes do |t|
      t.integer :attributable_id, null: false
      t.string :attributable_type, null: false, size: 50
      t.string :key, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_index :content_attributes, [:attributable_id, :attributable_type], name: 'index_content_attributes_on_attr_id_and_attr_type'
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
      t.string :reference_type, null: false
    end
    add_index :content_value_reference, :content_attribute_id
    add_index :content_value_reference, [:reference_type, :value]

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
