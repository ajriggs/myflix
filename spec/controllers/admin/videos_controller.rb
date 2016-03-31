require 'spec_helper'

describe Admin::VideosController do
  it { should use_before_action :require_admin }

  describe 'GET new' do
    let(:admin) { Fabricate :user, admin: true }

    before do
      test_login admin
      get :new
    end

    it 'sets @video as a new instance of the Video class' do
      expect(assigns :video).to be_a_new Video
    end
  end

  describe 'POST create' do
    let(:admin) { Fabricate :user, admin: true }

    context 'with valid inputs' do
      let(:video_params) { Fabricate.attributes_for :video }

      before do
        test_login admin
        post :create, video: video_params
      end

      it 'saves a new video to the database' do
        expect(Video.last.title).to eq video_params[:title]
      end

      it 'redirects to the new admin video path' do
        expect(response).to redirect_to new_admin_video_path
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid inputs' do
      let(:category) { Fabricate :category }
      let(:invalid_video_params) do
        { video: { title: '', tagline: '', category_id: category.id } }
      end

      before do
        test_login admin
        post :create, video: invalid_video_params
      end

      it 'does not save a new video to the database' do
        expect(Video.find_by title: invalid_video_params[:title]).to be nil
      end

      it 're-renders the upload video template' do
        expect(response).to render_template :new
      end

      it 'sets flash.now[:error]' do
        expect(flash.now[:error]).to be_present
      end
    end
  end
end
