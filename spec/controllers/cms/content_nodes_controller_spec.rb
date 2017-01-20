require 'rails_helper'

RSpec.describe Cms::ContentNodesController, :type => :controller do

  routes { Cms::Engine.routes }

  let(:contact_attrs) { attributes_for(:contact_component) }
  let(:text_attrs) { attributes_for(:text_component, :valid) }

  before do
    controller.class_eval do
      def current_cms_user
        user = Cms::User.new
        user.roles = ['admin']
        user
      end
    end
    Cms.current_user_method = :current_cms_user
  end

  context "#create" do
    before do
      allow(controller).to receive(:content_node_types).and_return ['TestNodes::Page']
      allow(controller).to receive(:content_component_types).and_return ['TestComponents::Contact', 'TestComponents::Text']
    end

    context "raises an error" do
      it "if no content node params are present" do
        expect{post :create }.to raise_error(ActionController::ParameterMissing)
        expect{post :create, content_node: attributes_for(:content_node, :invalid_type) }.to raise_error(Cms::SaferExecution::ClassNotAllowed)
      end
    end

    context "valid" do
      def valid_post
        params = attributes_for(:page, :valid).merge(
          {
            title: 'test',
            content_components_attributes: {'0': contact_attrs, '1': text_attrs}
          }
        )
        post(:create, content_node: params)
      end

      it "creates a new content_node" do
        expect { valid_post }.to change{ Cms::ContentNode.unscoped.count }.by(1)
      end

      it "creates a component" do
        expect { valid_post }.to change{ Cms::ContentComponent.count }.by(2)
      end

      it "redirects to index" do
        valid_post
        expect(response).to redirect_to content_nodes_path
      end
    end
  end

  context "#update" do
    let(:content_node) { create(:page, :valid) }
    let(:contact) { create(:contact_component, size: 1.1, componentable: content_node) }
    let(:text) { create(:text_component, :valid, componentable: content_node) }

    before do
      expect(controller).to receive(:content_node_types).at_least(:once).and_return [ 'TestNodes::Page' ]
      expect(controller).to receive(:content_component_types).at_least(:twice).and_return(['TestComponents::Contact', 'TestComponents::Text'])
    end

    def valid_put
      params = {
        type: content_node.class.to_s,
        content_components_attributes: {
          '0': contact_attrs.merge(id: contact.id),
          '1': text_attrs.merge(id: text.id)
        }
      }
      put( :update, id: content_node.id, content_node: params )
    end

    it "updates the components" do
      valid_put
      contact.reload
      expect( contact.size ).to eq contact_attrs[:size]
      expect( contact.first_name ).to eq contact_attrs[:first_name]
      expect( contact.last_name ).to eq contact_attrs[:last_name]

      text.reload
      expect( text.test_text ).to eq text_attrs[:test_text]
    end

    it "deletes the components" do
      params = {
        type: content_node.class.to_s,
        content_components_attributes: {
          '0': contact_attrs.merge(id: contact.id, '_destroy': '1'),
          '1': text_attrs.merge(id: text.id, '_destroy': '1')
        }
      }
      expect{put :update, id: content_node.id, content_node: params}.to change{ Cms::ContentComponent.count }.by(-2)
    end

    it "redirects to index" do
      valid_put
      expect(response).to redirect_to content_nodes_path
    end
  end
end
