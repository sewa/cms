module Cms
  module ContentAttributes
    module Concerns
      module ReferenceItem

        extend ActiveSupport::Concern

        included do

          def value=(value)
            if reference = reference(value)
              assign_value(reference.id)
            end
          end

          protected

          def reference(value)
            reference_class.find_by_id(value)
          end

        end

      end
    end
  end
end
