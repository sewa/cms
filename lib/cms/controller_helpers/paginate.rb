module Cms
  module ControllerHelpers
    module Paginate

      def assets_per_page
        Cms.assets_per_page || 16
      end

    end
  end
end
