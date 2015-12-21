class QueueItemsController < ApplicationController
  before_action :require_login

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find_by slug: params[:video_id]
    queue_item = QueueItem.create user: current_user, video: video, position: current_user.next_slot_in_queue
    if queue_item.valid?
      redirect_to my_queue_path, notice: 'added to your queue.'
    else
      @queue_items = current_user.queue_items
      flash.now[:error] = 'That video is already in your queue.'
      render :index
    end
  end

  def destroy
    queue_item = QueueItem.find params[:id]
    current_user.remove_from_queue!(queue_item)
    current_user.normalize_queue!
    redirect_to my_queue_path
  end

  def update
    begin
      current_user.update_queue!(params[:queue])
    rescue
      flash[:error] = 'Oops! Something went wrong.'
    end
    current_user.normalize_queue!
    redirect_to my_queue_path
  end
end
