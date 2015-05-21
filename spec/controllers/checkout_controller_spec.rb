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
      post :create, content_node: attributes_for(:content_node, :node_with_attrs)
    end

    it "creates a new content_node" do
      expect { valid_post }.to change{ Cms::ContentNode.count }.by(1)
    end

    it "redirects to index" do
      valid_post
      expect(response).to redirect_to content_nodes_path
    end

  end
end
