class AddUserToSnippets < ActiveRecord::Migration
  def change
    add_reference :snippets, :user, index: true, foreign_key: true
  end
end
