# encoding: utf-8
module Cms
  module ContentValue

    class Integer < ActiveRecord::Base
      self.table_name = 'content_value_integer'
      validates :value, numericality: { only_integer: true }
    end

    class  Float < ActiveRecord::Base
      self.table_name = 'content_value_float'
      validates :value, numericality: true
    end

    class String < ActiveRecord::Base
      self.table_name = 'content_value_string'
      validates :value, length: { maximum: 256 }
    end

    class Text < ActiveRecord::Base
      self.table_name = 'content_value_text'
    end

    class Datetime < ActiveRecord::Base
      self.table_name = 'content_value_datetime'
    end

    class Reference < ActiveRecord::Base
      self.table_name = 'content_value_reference'
      validates :reference_type, presence: true

      def value
        reference_type.constantize.find_by_id(read_attribute(:value))
      end
    end

  end
end
