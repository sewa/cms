class AddMetaRobotsToContentNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :content_nodes, :meta_noindex, :boolean
  end
end
