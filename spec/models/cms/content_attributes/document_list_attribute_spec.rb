require 'rails_helper'

module Cms
  RSpec.describe DocumentListAttribute, type: :model do

    3.times do |idx|
      let("document_#{idx}") { create(:content_document) }
    end

    def document_arr
      documents = []
      3.times do |idx|
        documents << self.send("document_#{idx}")
      end
      documents
    end

    def document_ids
      document_arr.map(&:id)
    end

    it "assigns a string" do
      attr = DocumentListAttribute.new
      attr.value = document_ids.join(',')
      expect(attr.value).to eq document_arr
    end

    it "assigns a string" do
      attr = DocumentListAttribute.new
      attr.value = document_ids
      expect(attr.value).to eq document_arr
    end

  end
end
