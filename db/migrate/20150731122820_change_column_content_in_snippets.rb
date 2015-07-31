class ChangeColumnContentInSnippets < ActiveRecord::Migration
  def change
    change_column :snippets,:content,:text,null: false
  end
end
