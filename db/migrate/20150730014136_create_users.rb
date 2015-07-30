class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :auth_token
      t.datetime :auth_token_expiration
      t.string :password_digest

      t.timestamps null: false
    end
    add_index :users, :email
  end
end
