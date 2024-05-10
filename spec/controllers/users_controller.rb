require 'rails_helper'

describe UsersController, type: :controller do
  let(:user_1) { create(:user, username: 'User1') }
  let(:user_2) { create(:user, username: 'User2') }
  let!(:room) { create(:room) }

  context 'when the user is sign in' do
    before(:each) do
      sign_in user_1
    end

    describe 'GET /user' do
      subject { get :show, params: { id: user_2.id } }

      it { is_expected.to have_http_status(:ok) }
    end
  end

  context 'when the user is not sign in' do
    it {
      get :show, params: { id: user_2.id }
      expect(response).to redirect_to('/users/sign_in')
    }
  end
end
