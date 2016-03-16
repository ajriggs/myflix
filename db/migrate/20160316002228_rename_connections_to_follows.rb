class RenameConnectionsToFollows < ActiveRecord::Migration
  def change
    rename_table :connections, :follows
  end
end
