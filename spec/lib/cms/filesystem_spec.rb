require 'rails_helper'

RSpec.describe Cms::Filesystem do

  class Test
    include Cms::Filesystem
  end

  let(:object) { Test.new }

  def types(node = nil)
    object.send(:content_node_types, node)
  end

  it "loads nodes" do
    expect(types).to eq ['Page', 'Page2', 'Page3', 'Page4']
  end

  it "loads sub nodes and common nodes if a node with sub nodes is present and common_sub_nodes is true" do
    res = ['SubPage', 'SubPage1', 'Page', 'Page2', 'Page3', 'Page4']
    expect(types(Page.new)).to eq res
    expect(types(Page)).to eq res
  end

  it "loads sub nodes if a node with sub nodes is present" do
    res = ['SubPage', 'SubPage1']
    expect(types(Page2.new)).to eq res
    expect(types(Page2)).to eq res
  end

  it "loads no subnodes if nothing is specified" do
    expect(types(Page3.new)).to eq []
    expect(types(Page3)).to eq []
  end

  it "loads sub nodes if cmmon_sub_nodes is true" do
    res = ['Page', 'Page2', 'Page3', 'Page4']
    expect(types(Page4.new)).to eq res
    expect(types(Page4)).to eq res
  end

end
