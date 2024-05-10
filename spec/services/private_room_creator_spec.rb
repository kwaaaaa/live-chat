require 'rails_helper'

describe PrivateRoomCreator do
  let(:user_1) { create(:user, username: 'User1') }
  let(:user_2) { create(:user, username: 'User2') }
  let(:user_3) { create(:user, username: 'User3') }
  let!(:private_room) { create(:room, name: 'private1', is_private: true, users: [user_1, user_2]) }
  let!(:another_room) { create(:room, name: 'private2', is_private: true) }

  describe '#find_or_create' do
    context 'when a room exists' do
      subject { described_class.new(user_1, user_2).find_or_create }

      it 'finds an existing room' do
        expect(subject).to eq(private_room)
      end
    end

    context 'when a room non exists' do
      subject { described_class.new(user_1, user_3).find_or_create }

      it 'creates a new room' do
        expect { subject }.to change { Room.count }.by(1)
      end

      it 'creates an association' do
        expect(subject.users).to eq([user_1, user_3])
      end
    end
  end
end
