module Cms
  module ContentAttributes
    module Concerns
      module ReferenceList

        extend ActiveSupport::Concern

        included do

          def value
            if value = fetch_value
              objects(to_arr(value))
            else
              []
            end
          end

          def value=(value)
            if objs = objects(to_arr(value))
              assign_value(to_csv( objs.map(&:id) ))
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

          def objects(ids)
            return @list_objects if @list_objects
            records = reference_class.where(id: ids)
            @list_objects = ids.map { |id| records.detect { |record| record.id == id.to_i }}.compact
          end

        end

      end
    end
  end
end
