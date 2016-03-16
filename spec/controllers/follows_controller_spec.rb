require 'spec_helper'

describe FollowsController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it "sets @folllows to the current user's guides (people they follow)" do
      riggs = Fabricate :user, full_name: 'Riggs'
      Fabricate.times(3, :follow, follower: riggs)
      test_login riggs
      get :index
      expect(assigns :follows).to eq riggs.follows_where_following
    end
  end

  describe 'DELETE destroy' do
    let(:riggs) { Fabricate :user, full_name: 'Riggs' }
    let(:james) { Fabricate :user, full_name: 'James' }
    let!(:follow_1) { Fabricate :follow, follower: riggs }
    let!(:follow_2) { Fabricate :follow, follower: james }

    before do
      test_login riggs
    end

    it "deletes the specified follow from the db, if the current user user is the follower in the given follow" do
      delete :destroy, id: follow_1.id
      expect(Follow.count).to eq 1
    end

    it "doesn't delete the specified follow from the db, if the current user is the not the follower in the given follow" do
      delete :destroy, id: follow_2.id
      expect(Follow.count).to eq 2
    end

    it 'redirects to the people path (people user is following)' do
      delete :destroy, id: follow_1.id
      expect(response).to redirect_to people_path
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user }
    let(:guide) { Fabricate :user }

    before do
      test_login user
    end

    it 'associates the current user as the follower in a new Follow instance' do
      post :create, user_id: guide.slug
      expect(Follow.last.follower).to eq user
    end

    it 'associates the provided user_id as the guide_id in a new Follow instance' do
      post :create, user_id: guide.slug
      expect(Follow.last.guide).to eq guide
    end

    it 'does not allow a user to follow another user more than once' do
      2.times { post :create, user_id: guide.slug }
      expect(user.guides.count).to eq 1
    end

    it 'does not allow a user to follow himself/herself' do
      post :create, user_id: user.slug
      expect(user.guides.count).to eq 0
    end

    it 'redirects to the people path' do
      post :create, user_id: guide.slug
      expect(response).to redirect_to people_path
    end
  end
end
