class AddIndexForContentNodesAccess < ActiveRecord::Migration[5.2]
  def change
    add_index :content_nodes, :access
  end
end
