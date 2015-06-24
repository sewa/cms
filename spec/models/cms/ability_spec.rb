# encoding: utf-8
require "rails_helper"
require 'matchers/cancan'

module Cms
  RSpec.describe Ability do

    before do
      Cms.user_class = User
      Cms.current_user_method = :current_user
    end

    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "admin" do

      let(:user) { User.new }

      before do
        user.roles = ['admin']
      end

      it { should have_abilities(:manage, ContentNode.new) }
      it { should have_abilities(:manage, ContentDocument.new) }
      it { should have_abilities(:manage, ContentImage.new) }
      it { should have_abilities(:manage, ContentCategory.new) }

    end

    context "cms_editor" do

      let(:user) { User.new }

      before do
        user.roles = ['cms_editor']
      end

      it { should have_abilities(:manage, ContentNode.new) }
      it { should have_abilities(:manage, ContentDocument.new) }
      it { should have_abilities(:manage, ContentImage.new) }
      it { should have_abilities(:manage, ContentCategory.new) }

    end

    context "someone" do

      let(:user) { User.new }

      before do
        user.roles = ['someone']
      end

      it { should_not have_abilities(:manage, ContentNode.new) }
      it { should_not have_abilities(:manage, ContentDocument.new) }
      it { should_not have_abilities(:manage, ContentImage.new) }
      it { should_not have_abilities(:manage, ContentCategory.new) }

    end
  end
end
