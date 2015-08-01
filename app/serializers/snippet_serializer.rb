class SnippetSerializer < ActiveModel::Serializer
  attributes :id,:title,:slug,:description,:content,:highlighted_content,
    :created_at,:updated_at,:category_id,:category_title,:link

  def category_title
    object.category.title
  end

  def link
    api_snippet_path(object)
  end
  def filter(keys)
    if  serialization_options[:short_form] == true
      keys -  [:content,:highlighted_content]
    else
      keys
    end
  end 
end
