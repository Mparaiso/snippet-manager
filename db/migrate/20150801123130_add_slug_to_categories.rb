class AddSlugToCategories < ActiveRecord::Migration
  def change

    add_column :categories, :slug, :string
    reversible do |direction|
      direction.up do
        Category.all.each(&:save)
      end
    end
    change_column_null :categories,:slug,false
    add_index :categories, :slug, unique: true 



  end
end
