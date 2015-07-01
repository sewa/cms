module Cms
  module AssetHelper

    def thumb_dimensions
      '135x135>'
    end

    def asset_url(asset)
      if image?(asset)
        asset.image.thumb(thumb_dimensions).url
      elsif document?(asset)
        asset.attachment.url
      end
    end

    def image?(asset)
      asset.class.name == 'Cms::ContentImage'
    end

    def document?(asset)
      asset.class.name == 'Cms::ContentDocument'
    end

  end
end
