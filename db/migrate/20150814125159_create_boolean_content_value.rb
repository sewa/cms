class CreateBooleanContentValue < ActiveRecord::Migration[5.2]
  def change
    create_table :content_value_boolean do |t|
      t.integer :content_attribute_id, null: false
      t.boolean :value, null: false
    end
    add_index :content_value_boolean, :content_attribute_id
  end
end
