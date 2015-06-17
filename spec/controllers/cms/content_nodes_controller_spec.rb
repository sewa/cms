require 'rails_helper'

RSpec.describe Cms::ContentNodesController, :type => :controller do
  routes { Cms::Engine.routes }

  context "#create" do

    before do
      expect(controller).to receive(:content_node_types).at_most(:twice).and_return ['TestNode']
      expect(controller).to receive(:content_component_types).at_most(:twice).and_return ['TestComponent', 'TestComponent1']
    end

    it "raises an error if no content node params are present" do
      expect{post :create }.to raise_error(ActionController::ParameterMissing)
      expect{post :create, content_node: attributes_for(:content_node, :invalid_type) }.to raise_error(Cms::SaferExecution::ClassNotAllowed)
    end

    def valid_post
      params = attributes_for(:content_node, :with_attrs).merge(content_components_attributes:
                                                                {
                                                                 '0': attributes_for(:test_comp),
                                                                 '1': attributes_for(:test_comp_1),
                                                                }
                                                               )
      post :create, content_node: params
    end

    it "creates a new content_node" do
      expect { valid_post }.to change{ Cms::ContentNode.count }.by(1)
    end

    it "creates a component" do
      expect { valid_post }.to change{ Cms::ContentComponent.count }.by(2)
    end

    it "redirects to index" do
      valid_post
      expect(response).to redirect_to content_nodes_path
    end

  end

  context "#update" do

    before do
      expect(controller).to receive(:content_node_types).at_most(:twice).and_return ['TestNode']
      expect(controller).to receive(:content_component_types).at_most(:twice).and_return ['TestComponent', 'TestComponent1']
    end

    it "updates the components" do
      comp1 = create(:test_comp, :with_node, float: 1.1)
      comp2 = create(:test_comp_1, componentable: comp1.componentable)
      node = comp1.componentable
      params = attributes_for(:content_node, :with_attrs).merge(content_components_attributes:
                                                                {
                                                                 '0': attributes_for(:test_comp).merge(id: comp1.id),
                                                                 '1': attributes_for(:test_comp_1).merge(id: comp2.id),
                                                                }
                                                               )
      expect{put :update, id: node.id, content_node: params}.to change{ Cms::ContentComponent.count }.by(0)
    end

    it "deletes the components" do
      comp1 = create(:test_comp, :with_node, float: 1.1)
      comp2 = create(:test_comp_1, componentable: comp1.componentable)
      node = comp1.componentable
      params = attributes_for(:content_node, :with_attrs).merge(content_components_attributes:
                                                                {
                                                                 '0': attributes_for(:test_comp).merge(id: comp1.id, '_destroy': '1'),
                                                                 '1': attributes_for(:test_comp_1).merge(id: comp2.id, '_destroy': '1'),
                                                                }
                                                               )
      expect{put :update, id: node.id, content_node: params}.to change{ Cms::ContentComponent.count }.by(-2)
    end

  end
end
