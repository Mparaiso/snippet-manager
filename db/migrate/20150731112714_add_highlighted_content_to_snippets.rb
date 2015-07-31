class AddHighlightedContentToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :highlighted_content, :text
  end
end
