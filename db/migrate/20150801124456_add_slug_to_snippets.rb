class AddSlugToSnippets < ActiveRecord::Migration
  def change

    add_column :snippets, :slug, :string
    reversible do |direction|
      direction.up do
        Snippet.all.each(&:save)
      end
    end
    change_column_null :snippets,:slug,false
    add_index :snippets, :slug, unique: true

  end
end
