class SnippetSerializer < ActiveModel::Serializer
  attributes :id,:title,:slug,:description,:content,:highlighted_content,
    :created_at,:updated_at,:category_id,:category_title
  def category_title
    object.category.title
  end
  
end
