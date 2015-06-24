# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe Cms::Concerns::Template do

    it "sets the template" do
      class TestTemplate < ActiveRecord::Base
        include Cms::Concerns::Template
        self.table_name = :content_nodes
        template 'test'
      end
      expect(TestTemplate.template).to eq 'test'
      expect(TestTemplate.new.template).to eq 'test'
      object = TestTemplate.new
      object.template = 'new'
      expect(object.template).to eq 'new'
    end

    context "validate" do

      class TestTemplateValidation < ActiveRecord::Base
        include Cms::Concerns::Template
        self.table_name = :content_nodes
      end

      it "does if template is nil" do
        expect(TestTemplateValidation.template).to eq nil
        object = TestTemplateValidation.new
        expect(object.valid?).to eq false
      end

      it "skips if template is false" do
        TestTemplateValidation.class_eval do
          template false
        end
        object = TestTemplateValidation.new
        expect(object.valid?).to eq true
      end
    end
  end
end
