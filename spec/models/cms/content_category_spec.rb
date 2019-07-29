require 'rails_helper'

module Cms
  RSpec.describe ContentCategory, type: :model do

    it { should have_and_belong_to_many :content_nodes }
    it { should validate_presence_of :name }

  end
end
