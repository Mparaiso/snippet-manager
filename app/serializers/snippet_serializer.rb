class SnippetSerializer < ActiveModel::Serializer
  attributes :id,:title,:slug,:description,:content,:highlighted_content,
    :created_at,:updated_at
  belong_to :category
end
