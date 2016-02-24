require 'spec_helper'
require 'shoulda-matchers'

describe QueueItemsController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it 'sets @queue_items to the queue items of the logged in user' do
      user = User.find test_login
      queue_items = 2.times.map { |i| Fabricate :queue_item, user: user, position: i + 1 }
      get :index
      expect(assigns :queue_items).to eq queue_items
    end
  end

  describe 'POST create' do
    let!(:user) { User.find test_login }
    let(:video) { Fabricate :video }
    let(:video_2) { Fabricate :video }

    before do
      post :create, video_id: video.slug
    end

    context "if the video is not yet in user's queue" do
      it 'associates a new queue item to the current user' do
        expect(user.queue_items.count).to eq 1
      end

      it 'associates a new queue item to the video selected' do
        expect(video.queue_items.count).to eq 1
      end

      it "sets the position of new item to the current user's next slot" do
        post :create, video_id: video_2.slug
        video_2_item = QueueItem.find_by user: user, video: video_2
        expect(video_2_item.position).to eq 2
      end

      it 'saves the queue item to the db' do
        expect(QueueItem.count).to eq 1
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_present
      end

      it 'redirects to the my queue path' do
        expect(response).to redirect_to my_queue_path
      end
    end

    context "if the video is in user's queue" do
      before { post :create, video_id: video.slug }

      it 'does not save the queue item to the db' do
        expect(QueueItem.count).to eq 1
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end

      it 'sets @queue_items' do
        expect(assigns :queue_items).to eq QueueItem.all
      end

      it 'renders the index template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'DELETE destroy' do
    let(:user) { Fabricate :user }
    let(:queue_item_1) { Fabricate :queue_item, user: user, position: 1}
    let(:queue_item_2) { Fabricate :queue_item, user: user, position: 2}
    let(:queue_item_3) { Fabricate :queue_item, user: user, position: 3}
    let(:queue) { [queue_item_1, queue_item_2, queue_item_3] }

    before do
      test_login(user)
      delete :destroy, id: queue[1].id
    end

    it "it deletes the item, if it's in the current user's queue" do
      expect(QueueItem.count).to eq 2
    end

    it "it does not delete the item, if it's not in the current user's queue" do
      new_item = Fabricate :queue_item
      delete :destroy, id: new_item.id
      expect(QueueItem.count).to eq 3
    end

    it "doesn't affect the position of preceding items in the user's queue" do
      expect(QueueItem.first.position).to eq 1
    end

    it "affects the position of subsequent items in the user's queue" do
      expect(QueueItem.last.position).to eq 2
    end

    it 'redirects to the my queue page' do
      expect(response).to redirect_to my_queue_path
    end
  end

  describe 'PATCH update' do
    context "with valid updates to current user's queue" do
      let(:user) { User.find test_login }
      let(:queue_item_1) { Fabricate :queue_item, user: user, position: 1}
      let(:queue_item_2) { Fabricate :queue_item, user: user, position: 2}
      let(:queue_item_3) { Fabricate :queue_item, user: user, position: 3}
      let(:queue_item_4) { Fabricate :queue_item, user: user, position: 4}
      let(:queue_item_5) { Fabricate :queue_item, user: user, position: 5}
      let(:queue) { [queue_item_1, queue_item_2, queue_item_3, queue_item_4, queue_item_5] }

      it 'redirects to the my queue page' do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position }
        end
        patch :update, queue: queue_params
        expect(response).to redirect_to my_queue_path
      end

      it "updates the positions of items in the queue, if positions were modified" do
        queue[0][:position] = 4
        queue[3][:position] = 1

        queue_params = queue.map do |item|
          { id: item.id, position: item.position }
        end
        patch :update, queue: queue_params
        expect(QueueItem.find(queue[0].id).position).to eq 4
      end

      it "reoders the users queue, according to position" do
        queue[0][:position] = 4
        queue[3][:position] = 1

        queue_params = queue.map do |item|
          { id: item.id, position: item.position }
        end
        patch :update, queue: queue_params
        expect(user.queue_items[0]).to eq queue[3]
      end

      it 'normalizes the queue order' do
        queue.each { |item| item.position += 1 }

        queue_params = queue.map do |item|
          { id: item.id, position: item.position }
        end
        patch :update, queue: queue_params
        expect(user.queue_items.map(&:position)).to eq [1, 2, 3, 4, 5]
      end

      it "updates the rating of all videos modified when updating the queue" do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position, rating: 1 }
        end
        patch :update, queue: queue_params
        expect(user.queue_items.map(&:rating)).to eq [1, 1, 1, 1, 1]
      end

      it "updates queue positions & video ratings, if both are changed" do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position, rating: 1 }
        end
        queue_params[0][:position] = 4
        queue_params[3][:position] = 1
        patch :update, queue: queue_params
        expect(user.queue_items.first.id).to eq queue_params[3][:id]
        expect(user.queue_items.map(&:rating)).to eq [1, 1, 1, 1, 1]
      end
    end

    context "with invalid updates to current user's queue items" do
      let(:user) { User.find test_login }
      let(:queue_item_1) { Fabricate :queue_item, user: user, position: 1}
      let(:queue_item_2) { Fabricate :queue_item, user: user, position: 2}
      let(:queue_item_3) { Fabricate :queue_item, user: user, position: 3}
      let(:queue_item_4) { Fabricate :queue_item, user: user, position: 4}
      let(:queue_item_5) { Fabricate :queue_item, user: user, position: 5}
      let(:queue) { [queue_item_1, queue_item_2, queue_item_3, queue_item_4, queue_item_5] }

      it 'sets flash[:error]' do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position + 0.5 }
        end
        patch :update, queue: queue_params
        expect(flash[:error]).to be_present
      end

      it 'redirects to the my queue page' do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position + 0.5 }
        end
        patch :update, queue: queue_params
        expect(response).to redirect_to my_queue_path
      end

      it "doesn't save updates to queue positions, even if some were valid" do
        queue_params = queue.map do |item|
          { id: item.id, position: item.position + 0.5 }
        end
        queue_params[0][:position] = 4
        patch :update, queue: queue_params
        expect(QueueItem.all).to eq queue
      end
    end
  end
end
