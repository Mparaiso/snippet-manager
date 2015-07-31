class ChangeUsers < ActiveRecord::Migration


  def change
    reversible do |direction|
      direction.up do
        User.all.each do |user|
          user.nickname = "nickname-#{user.id}"
          user.save
        end
      end
    end
    change_column :users,:email,:string,null: false,index: true,uniqueness: true
    change_column :users,:nickname,:string,null:false,index: true,uniqueness: true
  end

end
