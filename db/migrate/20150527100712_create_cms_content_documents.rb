class CreateCmsContentDocuments < ActiveRecord::Migration
  def change
    create_table :content_documents do |t|
      t.string :name, null: false
      t.string :tags
      t.string :attachment_file_name, null: false
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.datetime :attachment_updated_at
      t.timestamps null: false
    end
  end
end
