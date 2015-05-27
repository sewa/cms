module Cms
  module AssetHelper

    def asset_url(asset, style=nil)
      if image?(asset)
        asset.image.url(style || 'thumb')
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
