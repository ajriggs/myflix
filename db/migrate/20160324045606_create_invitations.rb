class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :email, :name, :token
      t.text :message
      t.timestamps
    end
  end
end
