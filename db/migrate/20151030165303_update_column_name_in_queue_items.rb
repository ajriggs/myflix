class UpdateColumnNameInQueueItems < ActiveRecord::Migration
  def change
    rename_column :queue_items, :queue_position, :position
  end
end
