class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates_presence_of :content
  validate :confirm_participant, on: :create

  broadcasts_to :room

  private

  def confirm_participant
    return unless room.is_private

    errors.add(:user, 'Must be participant to leave a message') if room.users.exclude? user
  end
end
