module Cms
  module ContentAttributes
    module Concerns
      module ReferenceList

        extend ActiveSupport::Concern

        included do

          def value
            if value = fetch_value
              object(to_arr(value))
            else
              []
            end
          end

          def value=(value)
            if object = object(to_arr(value))
              assign_value(to_csv( object.pluck(:id) ))
            end
          end

          protected

          def to_csv(arr)
            arr.join(',')
          end

          def to_arr(value)
            if value.instance_of? String
              value.split(',')
            elsif value.instance_of? Array
              value.compact
            else
              raise "Can not assign object of type #{value.class.name} as value."
            end
          end

          def object(ids)
            @object ||= reference_class.where(id: ids)
          end

        end

      end
    end
  end
end
