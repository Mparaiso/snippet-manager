class ChangeSnippets < ActiveRecord::Migration
  def change
    change_column_null :snippets,:user_id,false
    change_column_null :snippets,:category_id,false
  end
end
