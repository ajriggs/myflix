require 'spec_helper'

describe ResetPasswordsController do
  describe 'GET edit' do
    context 'with a valid token' do
      let(:riggs) { Fabricate :user}

      before do
        riggs.render_token!
        get :edit, token: riggs.token
      end

      it 'sets @user based on the token provided in the URL' do
        expect(assigns :user).to eq riggs
      end

      it 'renders the edit page' do
        expect(response).to render_template :edit
      end

    end

    context 'with expired token' do
      let(:riggs) { Fabricate :user}

      it 'redirects the user to the invalid token page' do
        first_token = riggs.render_token!
        riggs.render_token!
        get :edit, token: first_token
        expect(response).to redirect_to invalid_token_path
      end
    end

    context 'with invalid token' do
      let(:riggs) { Fabricate :user}

      it 'redirects the user to the invalid token page' do
        get :edit, token: 'kjagh2f2hnv2-m9mxwe1'
        expect(response).to redirect_to invalid_token_path
      end
    end
  end

  describe 'PATCH update' do
    context 'with a valid token' do
      let(:riggs) { Fabricate :user }

      before do
        riggs.render_token!
        patch :update, token: riggs.token, user: { password: 'new_password' }
      end

      it "updates the given user's password according to the param passed in" do
        expect(User.first.password_digest).to_not eq riggs.password_digest
      end

      it "clears the user's token attribute" do
        expect(User.first.token).to eq nil
      end

      it 'sets flash[:notice]' do
        expect(flash[:notice]).to be_present
      end

      it 'redirects to the login path' do
        expect(response).to redirect_to login_path
      end
    end

    context 'with an invalid token' do
      let(:riggs) { Fabricate :user }

      before do
        riggs.render_token!
        patch :update, token: 'kjdfjsflqefis', user: { password: 'new_password'}
      end

      it "does not clear a user's token" do
        expect(riggs.token).to_not be nil
      end

      it "does not update a user's password" do
        expect(User.first.password_digest).to eq riggs.password_digest
      end

      it 'redirects to the invalid token path' do
        expect(response).to redirect_to invalid_token_path
      end
    end
  end
end
