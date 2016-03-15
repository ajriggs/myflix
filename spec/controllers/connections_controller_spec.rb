require 'spec_helper'

describe ConnectionsController do
  it { should use_before_action :require_login }

  describe 'GET index' do
    it "sets @connections to the current user's guides (people they follow)" do
      riggs = Fabricate :user, full_name: 'Riggs'
      3.times { Fabricate :connection, follower: riggs }
      test_login riggs
      get :index
      expect(assigns :connections).to eq riggs.following_connections
    end
  end

  describe 'DELETE destroy' do
    let(:riggs) { Fabricate :user, full_name: 'Riggs' }
    let(:james) { Fabricate :user, full_name: 'James' }
    let!(:connection_1) { Fabricate :connection, follower: riggs }
    let!(:connection_2) { Fabricate :connection, follower: james }

    before do
      test_login riggs
    end

    it "sets @connection based on the id submitted by the user" do
      delete :destroy, id: connection_1.id
      expect(assigns :connection).to eq connection_1
    end

    it "deletes the specified connection from the db, if the logged in user is the connection's follower" do
      delete :destroy, id: connection_1.id
      expect(Connection.count).to eq 1
    end

    it "doesn't delete the specified connection from the db, if the logged in user is not the connection's follower" do
      delete :destroy, id: connection_2.id
      expect(Connection.count).to eq 2
    end

    it 'redirects to the people path (people user is following)' do
      delete :destroy, id: connection_1.id
      expect(response).to redirect_to people_path
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user }
    let(:guide) { Fabricate :user }

    before do
      test_login user
    end

    it 'associates the current user as the follower in a new Connection instance' do
      post :create, user_id: guide.slug
      expect(Connection.last.follower).to eq user
    end

    it 'associates the provided user_id as the guide_id in a new Connection instance' do
      post :create, user_id: guide.slug
      expect(Connection.last.guide).to eq guide
    end

    it 'does not allow a user to follow another user more than once' do
      2.times { post :create, user_id: guide.slug }
      expect(user.guides.count).to eq 1
    end

    it 'does not allow a user to follow themself' do
      post :create, user_id: user.slug
      expect(user.guides.count).to eq 0
    end

    it 'redirects to the people path' do
      post :create, user_id: guide.slug
      expect(response).to redirect_to people_path
    end
  end
end
