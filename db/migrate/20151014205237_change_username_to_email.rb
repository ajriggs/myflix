class ChangeUsernameToEmail < ActiveRecord::Migration
  def change
    remove_column :users, :username
    add_column :users, :email, :string
  end
end
