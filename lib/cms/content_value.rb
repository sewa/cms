# encoding: utf-8
module Cms
  module ContentValue

    class Integer < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_integer'
      validates :value, numericality: { only_integer: true }
    end

    class  Float < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_float'
      validates :value, numericality: true
    end

    class String < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_string'
      validates :value, length: { maximum: 256 }
    end

    class Boolean < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_boolean'
      validates :value, inclusion: { in: [true, false] }
    end

    class Text < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_text'
    end

    class Datetime < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_datetime'
    end

    class Reference < ActiveRecord::Base
      belongs_to :content_attribute
      self.table_name = 'content_value_reference'
      validates :reference_type, presence: true

      def value
        reference_type.constantize.unscoped.find_by_id(read_attribute(:value))
      end
    end

  end
end
