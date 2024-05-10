require 'rails_helper'

describe RoomsController, type: :controller do
  let(:user_1) { create(:user, username: 'User1') }
  let(:user_2) { create(:user, username: 'User2') }
  let(:user_3) { create(:user, username: 'User3') }
  let!(:room) { create(:room) }

  context 'when the user is sign in' do
    before(:each) do
      sign_in user_1
    end

    describe 'GET /index' do
      subject { get :index }

      it { is_expected.to have_http_status(:ok) }
    end

    describe 'GET /show' do
      context 'when the room is private' do
        let!(:private_room) { create(:room, name: 'private1', is_private: true, users: [user_1, user_2]) }

        context 'user is a participant' do
          subject { get :show, params: { id: private_room.id } }

          it { is_expected.to have_http_status(:ok) }
        end

        context 'user is not a participant' do
          before do
            sign_in user_3
          end

          subject { get :show, params: { id: private_room.id } }
          it { is_expected.to have_http_status(:forbidden) }
        end
      end
    end

    describe 'POST /create' do
      subject { post :create, params: { room: params }, format: :turbo_stream }

      context 'with valid params' do
        let(:params) { attributes_for(:room, name: 'bla bla bla') }

        it { is_expected.to have_http_status(:ok) }
        it { expect { subject }.to change(Room, :count).by(1) }
      end

      context 'with invalid params' do
        let(:params) { attributes_for(:room, name: '') }

        it { is_expected.to have_http_status(:unprocessable_entity) }
      end
    end
  end

  context 'when the user is not sign in' do
    it {
      get :index
      expect(response).to redirect_to('/users/sign_in')
    }
  end
end
