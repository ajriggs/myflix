class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string :full_name
      t.string :username
      t.string :slug
      t.string :password_digest
    end
  end
end
