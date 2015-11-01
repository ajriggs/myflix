require 'spec_helper'
require 'shoulda-matchers'

include Testable


describe QueueItemsController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it 'sets @queue_items to the queue items of the logged in user' do
      user = User.find test_login
      queue_items = 2.times.map { |n| Fabricate :queue_item, user: user, position: n + 1 }
      get :index
      expect(assigns :queue_items).to eq queue_items
    end
  end

  describe 'POST create' do
    let(:user) { User.find test_login }
    let(:video) { Fabricate :video }
    let(:video_2) { Fabricate :video }

    before do
      user
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
        video_2_item = QueueItem.where(user: user, video: video_2).first
        expect(video_2_item.position).to eq 2
      end

      it 'saves the queue item to the db' do
        expect(QueueItem.count).to eq 1
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
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
        expect(flash[:error]).to be_a String
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
    let(:queue) do
      3.times.map { |n| Fabricate :queue_item, position: n + 1, user: user}
    end

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
end
