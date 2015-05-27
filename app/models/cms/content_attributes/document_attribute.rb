# endcoding: utf-8
class DocumentAttribute < Cms::ContentAttribute
  content_type :reference, 'Cms::ContentDocument'
end
