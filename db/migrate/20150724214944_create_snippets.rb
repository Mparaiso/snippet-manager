class CreateSnippets < ActiveRecord::Migration
  def change
    create_table :snippets do |t|
      t.string :title , null: false
      t.string :content, null: false

      t.timestamps null: false
    end
  end
end
