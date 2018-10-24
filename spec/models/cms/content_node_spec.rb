# encoding: utf-8
require "rails_helper"

module Cms
  RSpec.describe ContentNode, type: :model do

    let(:subject) { create(:content_node) }

    it { is_expected.to have_many :content_attributes }
    it { is_expected.to have_many :content_components }
    it { is_expected.to have_and_belong_to_many :content_categories }
    it { is_expected.to have_and_belong_to_many :content_nodes }
    it { is_expected.to have_and_belong_to_many :content_nodes_inversed }

    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :template }
    it { is_expected.to validate_uniqueness_of(:url) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to( :parent_id ) }

    it "can be created" do
      expect(subject).to be_persisted
    end

    it 'is not valid with an invalid component' do
      expect(subject.valid?).to eq true
      subject.content_components << build(:text_component, componentable: subject)
      expect(subject.valid?).to eq false
    end

    context "content_categories" do

      it "saves the categories" do
        c1 = build(:content_category)
        subject.content_categories = [c1]
        expect(subject.content_categories.count).to eq 1
      end

    end

    context "#path" do

      it "returns path" do
        expect(subject.path).to match(/name-\d/)
      end

      it "returns url if url is present" do
        url = 'test/url'
        subject.url = url
        expect(subject.path).to eq '/' + url
      end

    end

    context "#correct_redirect" do

      it "does nothing if redirect doesn't start with a slash" do
        subject.redirect = 'test/test'
        subject.valid?
        expect(subject.redirect).to eq 'test/test'
      end

      it "removes slash before validation" do
        subject.redirect = '/test/test'
        subject.valid?
        expect(subject.redirect).to eq 'test/test'
      end

      it "not raise an error if redirect is blank" do
        expect{subject.valid?}.not_to raise_error
      end

    end

    context "#correct_url" do

      it "does nothing if url doesn't start with a slash" do
        subject.url = 'test/test'
        subject.valid?
        expect(subject.url).to eq 'test/test'
      end

      it "removes slash before validation" do
        subject.url = '/test/test'
        subject.valid?
        expect(subject.url).to eq 'test/test'
      end

      it "not raises an error if url is blank" do
        expect{subject.valid?}.not_to raise_error
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

      let(:contact_attrs) { attributes_for(:contact_component) }
      let(:text_attrs) { attributes_for(:text_component, :valid) }

      it "builds the new components" do
        subject.content_components_attributes = hash([contact_attrs, text_attrs])
        subject.save
        expect(subject.content_components.count).to eq 2
        expect(subject.content_components.first.first_name).to eq contact_attrs[ :first_name ]
        expect(subject.content_components.first.last_name).to eq contact_attrs[ :last_name ]
        expect(subject.content_components.first.size).to eq contact_attrs[ :size ]
        expect(subject.content_components.last.test_text).to eq text_attrs[ :test_text ]
      end

      it "updates the existing" do
        contact = create(:contact_component, componentable: subject, size: 1.1)
        text = create(:text_component, test_text: 'test text', componentable: subject)

        expect(contact.size).to eq 1.1
        expect(contact.position).to eq 1

        expect(text.test_text).to eq 'test text'
        expect(text.position).to eq 2

        expect(subject.content_components.size).to eq 2

        subject.content_components_attributes = hash(
          [
            text_attrs.merge(test_text: 'abc'),
            contact_attrs.merge(id: contact.id, size: 11.11),
            text_attrs.merge(id: text.id, test_text: 'cde')
          ]
         )
        subject.save!

        expect(subject.content_components.first.test_text).to eq 'abc'
        expect(subject.content_components.first.position).to eq 1

        expect(contact.reload.size).to eq 11.11
        expect(contact.position).to eq 2

        expect(text.reload.test_text).to eq 'cde'
        expect(text.position).to eq 3
      end

      it "removes the unused" do
        comp = create(:contact_component, componentable: subject, size: 1.1)
        subject.content_components_attributes = hash(
          [contact_attrs.merge(id: comp.id, _destroy: '1')]
        )
        expect{ subject.save }.to change{ subject.content_components.count }.by(-1)
      end

    end

    context "#destroy_content_attributes" do

      it 'destroys the attributes' do
        node = create(:page, :valid)
        expect{ node.destroy_content_attributes(test_image: 1) }.to change{ ContentAttribute.count }.by(-1)
      end

    end

    context "list" do

      let!(:node1) { create(:page, :public, :valid, position: 1) }
      let!(:node2) { create(:page, :public, :valid, position: 2) }
      let!(:node3) { create(:page, :public, :valid, position: 3) }
      let!(:node4) { create(:page, :public, :valid, position: 4) }
      let!(:node5) { create(:page, :public, :valid, position: 5) }
      let!(:node6) { create(:page, :public, :valid, position: 6) }

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

    describe "#meta_robots" do
      let(:meta_noindex) { nil }
      let(:subject) { create(:content_node, meta_noindex: meta_noindex).meta_robots }

      it { is_expected.to eql('') }

      context do
        let(:meta_noindex) { false }
        it { is_expected.to eql('') }
      end

      context do
        let(:meta_noindex) { true }
        it { is_expected.to eql('noindex') }
      end
    end

  end
end
