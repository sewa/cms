require 'rails_helper'

RSpec.describe Cms::Filesystem do

  class Test
    include Cms::Filesystem
  end

  let(:object) { Test.new }

  context "content_nodes" do

    def types(node = nil)
      object.send(:content_node_types, node)
    end

    it "loads nodes" do
      expect(types).to eq ['Page', 'Page2', 'Page3', 'Page4', 'Page5', 'Page6']
    end

    it "loads child_node" do
      res = ['Page2', 'Page3']
      expect(types(Page.new)).to eq res
      expect(types(Page)).to eq res
    end

    it "loads child_nodes" do
      res = ['Page', 'Page3']
      expect(types(Page2.new)).to eq res
      expect(types(Page2)).to eq res
    end

    it "loads only child_nodes" do
      res = ['Page1', 'Page2']
      expect(types(Page3.new)).to eq res
      expect(types(Page3)).to eq res
    end

    it "loads all except child_nodes" do
      res = ['Page', 'Page3', 'Page4', 'Page5', 'Page6']
      expect(types(Page4.new)).to eq res
      expect(types(Page4)).to eq res
    end

    it "loads all except child_nodes" do
      expect(types(Page5.new)).to eq []
      expect(types(Page5)).to eq []
    end

    it "loads all" do
      expect(types(Page6.new)).to eq ['Page', 'Page2', 'Page3', 'Page4', 'Page5', 'Page6']
      expect(types(Page6)).to eq ['Page', 'Page2', 'Page3', 'Page4', 'Page5', 'Page6']
    end

  end

  context "content_components" do

    def types(node = nil)
      object.send(:content_component_types, node)
    end

    it "loads show_component" do
      res = ['TestComponent', 'TestComponent2']
      expect(types(Page.new)).to eq res
      expect(types(Page)).to eq res
    end

    it "loads show_components" do
      res = ['TestComponent']
      expect(types(Page2.new)).to eq res
      expect(types(Page2)).to eq res
    end

    it "loads show_components" do
      res = ['TestComponent2']
      expect(types(Page3.new)).to eq res
      expect(types(Page3)).to eq res
    end

    it "loads show_components" do
      res = ['TestComponent']
      expect(types(Page4.new)).to eq res
      expect(types(Page4)).to eq res
    end

    it "loads none if none is specified" do
      expect(types(Page5.new)).to eq []
      expect(types(Page5)).to eq []
    end

    it "loads show_component" do
      res = ['TestComponent', 'TestComponent2']
      expect(types(Page6.new)).to eq res
      expect(types(Page6)).to eq res
    end

  end

end
