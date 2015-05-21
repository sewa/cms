# encoding: utf-8
module Cms
  module ContentValue

    module Validation

      extend ActiveSupport::Concern

      included do
        validates :value, presence: true
      end

    end

    class Integer < ActiveRecord::Base
      self.table_name = 'content_value_integer'
      include Validation
      validates :value, numericality: { only_integer: true }
    end

    class  Float < ActiveRecord::Base
      self.table_name = 'content_value_float'
      include Validation
      validates :value, numericality: true
    end

    class String < ActiveRecord::Base
      self.table_name = 'content_value_string'
      include Validation
      validates :value, length: { maximum: 256 }
    end

    class Text < ActiveRecord::Base
      self.table_name = 'content_value_text'
      include Validation
    end

    class Datetime < ActiveRecord::Base
      self.table_name = 'content_value_datetime'
      include Validation
    end

    class Reference < ActiveRecord::Base
      self.table_name = 'content_value_reference'
      include Validation
      validates :type, presence: true

      def value
        type.constantize.find_by_id(read_attribute(:value))
      end
    end

  end
end
