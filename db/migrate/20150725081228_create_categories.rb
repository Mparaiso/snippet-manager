class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name,index:true,unique:true,name:false
      
      t.timestamps null: false
    end
  end
end
