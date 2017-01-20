module Cms
  module Concerns
    module Template
      extend ActiveSupport::Concern

      included do
        validates :template, presence: true, if: -> (n) { n.class.template.nil? && n.class.template != false }

        def template
          if read_attribute(:template).blank?
            self.class.template
          else
            read_attribute(:template)
          end
        end
      end

      class_methods do
        def template(template = nil)
          unless template.nil?
            @template = template
          else
            @template
          end
        end
      end
    end
  end
end
