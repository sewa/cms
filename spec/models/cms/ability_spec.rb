# encoding: utf-8
require "rails_helper"
require 'matchers/cancan'

module Cms
  RSpec.describe Ability do

    class User
      def roles
        []
      end
    end

    before do
      Cms.user_class = User
      Cms.user_roles_attribute = :roles
    end

    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "admin" do

      let(:user) { User.new }

      before do
        expect(user).to receive(:roles).at_least(:once).and_return(['admin'])
      end

      it { should have_abilities(:manage, ContentNode.new) }
      it { should have_abilities(:manage, ContentDocument.new) }
      it { should have_abilities(:manage, ContentImage.new) }
      it { should have_abilities(:manage, ContentCategory.new) }

    end

    context "cms_editor" do

      let(:user) { User.new }

      before do
        expect(user).to receive(:roles).at_least(:once).and_return(['cms_editor'])
      end

      it { should have_abilities(:manage, ContentNode.new) }
      it { should have_abilities(:manage, ContentDocument.new) }
      it { should have_abilities(:manage, ContentImage.new) }
      it { should have_abilities(:manage, ContentCategory.new) }

    end
  end
end
