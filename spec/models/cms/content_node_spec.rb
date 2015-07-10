# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentNode, type: :model do

    let(:node) { create(:content_node) }

    it { validate_presence_of :title }
    it { validate_presence_of :template }
    it { have_many :content_attributes }

    it "can be created" do
      expect(node).to be_persisted
    end

    it "can have many content_components" do
      node.content_components << [create(:test_comp, :with_node)]
      expect(node.content_components.count).to eq 1
    end

    context "content_categories" do

      it "saves the categories" do
        c1 = build(:content_category)
        node.content_categories = [c1]
        expect(node.content_categories.count).to eq 1
      end

    end

    context "#path" do

      it "returns path" do
        expect(node.path).to match /node-\d/
      end

      it "returns url if url is present" do
        url = 'test/url'
        node.url = url
        expect(node.path).to eq '/' + url
      end

    end

    context "#correct_redirect" do

      it "does nothing if redirect doesn't start with a slash" do
        node.redirect = 'test/test'
        node.valid?
        expect(node.redirect).to eq 'test/test'
      end

      it "removes slash before validation" do
        node.redirect = '/test/test'
        node.valid?
        expect(node.redirect).to eq 'test/test'
      end

      it "not raise an error if redirect is blank" do
        expect{node.valid?}.not_to raise_error
      end

    end

    context "#correct_url" do

      it "does nothing if url doesn't start with a slash" do
        node.url = 'test/test'
        node.valid?
        expect(node.url).to eq 'test/test'
      end

      it "removes slash before validation" do
        node.url = '/test/test'
        node.valid?
        expect(node.url).to eq 'test/test'
      end

      it "not raises an error if url is blank" do
        expect{node.valid?}.not_to raise_error
      end

    end

    context "#content_components_attributes" do

      def hash(arr)
        h = {}
        arr.each_with_index do |v,k|
          h[k.to_s] = v
        end
        h
      end

      let(:comp1) { attributes_for(:test_comp).reject{ |k,v| k == :content_node } }
      let(:comp2) { attributes_for(:test_comp).reject{ |k,v| k == :content_node } }
      let(:comp3) { attributes_for(:test_comp_1).reject{ |k,v| k == :content_node } }

      it "builds the new components" do
        node.content_components_attributes = hash([comp1, comp2])
        node.save
        expect(node.content_components.count).to eq 2
        expect(node.content_components.last.float).to eq 12.1
        expect(node.content_components.last.text).to eq 'some text'
      end

      it "updates the existing" do
        comp = create(:test_comp, :with_node, float: 1.1)
        comp_a = create(:test_comp, float: 99.99, componentable: comp.componentable)

        expect(comp.float).to eq 1.1
        expect(comp.position).to eq 1

        expect(comp_a.float).to eq 99.99
        expect(comp_a.position).to eq 2

        node = comp.componentable
        expect(node.content_components.size).to eq 2
        node.content_components_attributes = hash([comp2.merge(float: 11.11), comp1.merge(id: comp.id), comp1.merge(id: comp_a.id, float: 99.99)])
        node.save

        expect(node.content_components.first.float).to eq 11.11
        expect(node.content_components.first.position).to eq 1

        expect(comp.reload.float).to eq 12.1
        expect(comp.position).to eq 2

        expect(comp_a.reload.float).to eq 99.99
        expect(comp_a.position).to eq 3
      end

      it 'is not valid when components are invalid' do
        comp = create(:validate_comp, :with_node, test: '123')
        node = comp.componentable
        expect(node.content_components.size).to eq 1
        expect(node.valid?).to eq true
        comp.test = nil
        node.content_components = [comp]
        expect(node.valid?).to eq false
      end

      it "removes the unused" do
        comp = create(:test_comp, :with_node, float: 1.1)
        node = comp.componentable
        node.content_components_attributes = hash([comp1.merge(id: comp.id, _destroy: '1')])
        node.save
        expect(node.reload.content_components.count).to eq 0
      end

    end

    context "#destroy_content_attributes" do

      it 'destroys the attributes' do
        node = create(:test_node)
        expect{ node.destroy_content_attributes(test2: 1) }.to change{ ContentAttribute.count }.by(-1)
      end

    end

    context "list" do

      let!(:node1) { create(:test_node, :public, position: 1) }
      let!(:node2) { create(:test_node, :public, position: 2) }
      let!(:node3) { create(:test_node, :public, position: 3) }
      let!(:node4) { create(:test_node, :public, position: 4) }
      let!(:node5) { create(:test_node, :public, position: 5) }
      let!(:node6) { create(:test_node, :public, position: 6) }

      let!(:cat1) { create(:content_category) }
      let!(:cat2) { create(:content_category) }

      before do
        node1.content_categories << cat1
        node2.content_categories << cat2
        node3.content_categories << cat1
        node4.content_categories << cat2
        node5.content_categories << cat2
        node6.content_categories << cat1
      end

      context "#next_public_item" do

        it "returns the next item" do
          expect(node1.next_public_item).to eq node2
        end

        it "cycles through the list" do
          expect(node6.next_public_item).to eq node1
        end

        it "uses the category ids" do
          expect(node1.next_public_item([ cat1.id ])).to eq node3
        end

        it "cycles through the list using the category ids" do
          expect(node5.next_public_item([ cat2.id ])).to eq node2
        end

      end

      context "#prev_public_item" do

        it "returns the prev item" do
          expect(node3.prev_public_item).to eq node2
        end

        it "cycles through the list" do
          expect(node1.prev_public_item).to eq node6
        end

        it "uses the category ids" do
          expect(node6.prev_public_item([ cat1.id ])).to eq node3
        end

        it "cycles through the list using the category ids" do
          expect(node2.prev_public_item([ cat2.id ])).to eq node5
        end


      end

    end

  end
end
