class AddMetaCanonicalToContentNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :content_nodes, :meta_canonical, :string, limit: 1024
  end
end
