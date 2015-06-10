require 'rails_helper'

RSpec.describe Cms::ContentNodesController, :type => :controller do
  routes { Cms::Engine.routes }

  context "#create" do

    before do
      expect(controller).to receive(:content_node_types).at_most(:twice).and_return ['TestNode']
    end

    it "raises an error if no content node params are present" do
      expect{post :create }.to raise_error(ActionController::ParameterMissing)
      expect{post :create, content_node: attributes_for(:content_node, :invalid_type) }.to raise_error(Cms::SaferExecution::ClassNotAllowed)
    end

    def valid_post
      params = attributes_for(:content_node, :with_attrs).merge(content_components_attributes:
                                                                {
                                                                 '0': attributes_for(:content_component, :with_attrs, :without_node),
                                                                 '1': attributes_for(:content_component, :with_attrs, :without_node),
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
end
