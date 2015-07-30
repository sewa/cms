class AddIndexForContentNodesAccess < ActiveRecord::Migration
  def change
    add_index :content_nodes, :access
  end
end
