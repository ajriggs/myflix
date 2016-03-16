class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :follower_id, :guide_id
      t.timestamps
    end
  end
end
