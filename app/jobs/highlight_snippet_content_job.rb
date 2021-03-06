class HighlightSnippetContentJob < ActiveJob::Base
  queue_as :default

  def perform(snippet)
    category = snippet.category.title.downcase.parameterize.underscore.to_sym
      
    snippet.update_column(:highlighted_content,
      CodeRay.scan(snippet.content,category).div(:line_numbers => :table))
    return true 
  end
end
