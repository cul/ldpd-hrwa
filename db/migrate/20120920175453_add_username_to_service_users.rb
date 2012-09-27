class AddUsernameToServiceUsers < ActiveRecord::Migration
  def change
    add_column :service_users, :username, :string
    add_index :service_users, :username, :unique => true
  end
end
