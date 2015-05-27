module Cms
  class ContentDocument < ActiveRecord::Base
    self.table_name = :content_documents

    has_attached_file :attachment,
      url: '/content/documents/:id/:basename.:extension',
      path: ':rails_root/public/content/documents/:id/:basename.:extension'

    validates_attachment :attachment,
      presence: true,
      content_type: { :content_type => %w(application/pdf) }

    validates :name, presence: true

  end
end
