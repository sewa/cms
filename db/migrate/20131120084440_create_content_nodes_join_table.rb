class CreateContentNodesJoinTable < ActiveRecord::Migration
  def change
    create_table :content_node_connections, :id => false, :force => true do |t|
      t.integer :content_node_id_1, :null => false
      t.integer :content_node_id_2, :null => false
    end
    add_index :content_node_connections, :content_node_id_1
    add_index :content_node_connections, :content_node_id_2
  end
end
