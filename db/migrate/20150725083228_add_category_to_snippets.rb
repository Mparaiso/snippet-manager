class AddCategoryToSnippets < ActiveRecord::Migration
  def change
    add_reference :snippets, :category, index: true, foreign_key: true
  end
end
