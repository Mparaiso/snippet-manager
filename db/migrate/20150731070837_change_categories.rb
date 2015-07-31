class ChangeCategories < ActiveRecord::Migration
  def change
    change_column_null :categories,:title,false
    change_column_null :categories,:description,false
    remove_column :users,:auth_token_expiration
  end
end
