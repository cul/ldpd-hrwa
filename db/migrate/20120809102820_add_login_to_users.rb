class AddLoginToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :login, :string, :unique =>true
    add_column :users, :password_salt, :string
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  end

end
