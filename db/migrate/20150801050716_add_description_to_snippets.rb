class AddDescriptionToSnippets < ActiveRecord::Migration
  def change
    add_column :snippets, :description, :string
  end
end
