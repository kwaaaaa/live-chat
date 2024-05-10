require 'rails_helper'

describe MessagesController, type: :controller do
  let(:user_1) { create(:user, username: 'User1') }
  let!(:room) { create(:room) }

  context 'when the user is sign in' do
    before(:each) do
      sign_in user_1
    end

    describe 'POST /create' do
      subject { post :create, params: { room_id: room.id, message: params }, format: :turbo_stream }

      context 'with valid params' do
        let(:params) { attributes_for(:message, room_id: room.id) }

        it { is_expected.to have_http_status(:ok) }
        it { expect(subject).to render_template('messages/create') }
        it { expect(subject.media_type).to eq Mime[:turbo_stream] }
        it { expect { subject }.to change(Message, :count).by(1) }
      end

      context 'with invalid params' do
        let(:params) { attributes_for(:message, content: '', room_id: room.id) }

        it { is_expected.to have_http_status(:unprocessable_entity) }
        it { expect(subject).to render_template('layouts/_flash') }
        it { expect(subject.media_type).to eq Mime[:turbo_stream] }
        it { expect { subject }.not_to change(Message, :count) }
      end
    end
  end

  context 'when the user is not sign in' do
    it {
      post :create, params: { room_id: room.id, message: {} }, format: :turbo_stream
      expect(response).to redirect_to('/users/sign_in')
    }
  end
end
