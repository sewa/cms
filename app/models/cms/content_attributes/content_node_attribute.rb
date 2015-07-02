# endcoding: utf-8
class ContentNodeAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentNode'
end
