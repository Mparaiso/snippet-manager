class RenameNameToTitleInCategories < ActiveRecord::Migration
  def change
    change_table :categories do |t|
      t.rename :name,:title
    end 
  end
end
