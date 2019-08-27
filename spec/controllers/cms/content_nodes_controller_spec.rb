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
        expect{post :create, params: { content_node: attributes_for(:content_node, :invalid_type) } }.to raise_error(Cms::SaferExecution::ClassNotAllowed)
      end
    end

    context "valid" do
      context 'without parent' do
        def valid_post
          params = attributes_for(:page, :valid).merge(
            {
              title: 'test',
              content_components_attributes: {'0': contact_attrs, '1': text_attrs}
            }
          )
          post(:create, params: { content_node: params })
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
  end

  context "#update" do
    let(:content_node) { create(:page, :valid, parent: create(:page, :valid, parent_id: nil)) }
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
      put(:update, params: { id: content_node.id, content_node: params })
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
      expect{put :update, params: { id: content_node.id, content_node: params }}.to change{ Cms::ContentComponent.count }.by(-2)
    end

    it "redirects to index" do
      valid_put
      expect(response).to redirect_to content_nodes_path
    end
  end

  context '#sort' do
    let(:parent_node) { create :content_node, :public }
    let(:first_node) { create :content_node, parent_id: parent_node.id, position: 1 }
    let(:second_node) { create :content_node, parent_id: parent_node.id, position: 2 }
    let(:third_node) { create :content_node, parent_id: parent_node.id, position: 3 }

    context 'if there is parent node' do
      it 'touches parent node' do
        allow(controller).to receive_message_chain(:unscoped, :with_relations, :find).and_return third_node
        allow(third_node).to receive(:set_list_position).with('1')
        allow(Cms::ContentNode).to receive_message_chain(:unscoped, :find_by).and_return parent_node
        expect(parent_node).to receive :touch
        post(:sort, params: { id: third_node.id, position: 1 })
      end
    end

    it 'changes content_node position' do
      allow(controller).to receive_message_chain(:unscoped, :with_relations, :find).and_return third_node
      expect(third_node).to receive(:set_list_position).with('1')
      post(:sort, params: { id: third_node.id, position: 1 })
    end

    it 'does not change timestamps' do
      first_current_updated_at = first_node.updated_at
      second_current_updated_at = second_node.updated_at
      third_current_updated_at = third_node.updated_at
      allow(controller).to receive_message_chain(:unscoped, :with_relations, :find).and_return third_node
      post(:sort, params: { id: third_node.id, position: 1 })
      expect(second_node.updated_at).to eq second_current_updated_at
      expect(first_node.updated_at).to eq first_current_updated_at
      expect(third_node.updated_at).to eq third_current_updated_at
    end
  end
end
