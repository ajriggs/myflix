require 'spec_helper'
require 'shoulda-matchers'

describe ReviewsController do
  it { should use_before_action :require_login }

  describe 'POST create' do
    let(:video) { Fabricate :video }
    let(:current_user_id) { test_login }
    let(:review_params) { Fabricate.attributes_for :review }

    before { current_user_id }

    context 'always' do
      before { post :create, video_id: video, review: review_params }

      it 'sets @video to the video being viewed' do
        expect(assigns(:video).id).to eq video.id
      end

      it 'associates @review to the viewed video' do
        expect(assigns :review).to eq video.reviews.first
      end

      it "associates @review to the current user" do
        expect(assigns(:review).user_id).to eq current_user_id
      end
    end

    context 'with valid input' do
      before { post :create, video_id: video, review: review_params }

      it 'saves the review to the database' do
        expect(Video.first.reviews.count).to eq 1
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_a String
      end

      it 'redirects to the video#show action for the reviewed video' do
        expect(response).to redirect_to video_path(video)
      end
    end

    context 'with invalid input' do
      before { post :create, video_id: video, review: { rating: 0 } }

      it 'does not save the review to the database' do
        expect(Video.first.reviews.empty?).to be true
      end

      it 'sets flash[:error]' do
        expect(flash[:error]).to be_present
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end
    end
  end
end
